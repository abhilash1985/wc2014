class DailyChallenge < ActiveRecord::Base
  has_many :matches, :dependent => :destroy
  has_many :daily_challenges_users, :dependent => :destroy
  has_many :users, through: :daily_challenges_users
  has_many :predictions, through: :daily_challenges_users
  
  scope :active, lambda { where("end_date >= ?", Date.today) }
  scope :active_today, lambda { where("'#{Date.today.to_s} 09:00:00' between start_date and end_date" ) }
  scope :today, lambda { where(:end_date => Date.today.beginning_of_day..Date.today.end_of_day ) }
  scope :weekly, lambda { |date = Date.today| where(:end_date => date.beginning_of_week.beginning_of_day..date.end_of_week.end_of_day).order(:id) }
  scope :by_name, lambda { |name| where(name: name) }
  scope :by_id, lambda { |id| where(id: id) }
  scope :last_challenge, lambda { where("end_date <= ?", Date.today ) }
  scope :not_today, lambda { where.not(:id => DailyChallenge.active_today) }
  
  validates :name, :start_date, :end_date, :presence => true
  validates :name, :uniqueness => true
  
  class << self
    def create_daily_challenge(name, start_date, end_date)
      challenge = DailyChallenge.by_name(name).first_or_initialize
      challenge.name = name
      challenge.start_date = start_date.to_s + ' 00:00'
      challenge.end_date = end_date.to_s + ' 18:00'
      challenge.save!
      challenge
    end
  end
  
  def create_match(game_id, match_name, played_on, team_a_score, team_b_score, result, stage, options)
    match = self.matches.where(game_id: game_id).first_or_initialize
    match.match = match_name
    ['game_id', 'played_on', 'team_a_score', 'team_b_score', 'result', 'stage', 'options'].each { |column|
      match.send("#{column}=", eval(column))
    }
    match.save!
    match
  end
  
  def total_points
    matches.inject(0){ |a, v| a += v.points.to_i }
  end
  
  def has_predictions?
    not predictions.blank?
  end
  
  def winner_array
    winner_hash.sort_by{|k, v| k }.reverse[0] rescue ['', []]
  end
  
  def winner_hash
    total_points_by_users.sort_by{|k, v| v.to_i }.inject({}){ |hash, value| 
      hash[value[1]] = hash[value[1]].blank? ? [value[0]] : hash[value[1]].push(value[0])  
      hash 
    }
  end
  
  def total_points_by_users
    users.inject({}){|hash, user| hash[user.show_name] = user.total_points_for_challenge(self); hash }
  end
  
  def winner_text
    "#{name} winner is #{winner_array[1].join(',').strip.upcase} with #{winner_array[0]} points#{winner_last_text}"
  end
  
  def multiple_winners?
    winner_array[1].count > 1
  end
  
  def winner_last_text
    " each" if multiple_winners?
  end
end