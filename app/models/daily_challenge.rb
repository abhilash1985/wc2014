class DailyChallenge < ActiveRecord::Base
  has_many :matches
  has_many :daily_challenges_users
  has_many :users, through: :daily_challenges_users
  
  scope :active, lambda { where("end_date >= ?", Date.today) }
  scope :active_today, lambda { where("'#{Date.today.to_s} 09:00:00' between start_date and end_date" ) }
  scope :by_name, lambda { |name| where(name: name) }
  
  validates :name, :start_date, :end_date, :presence => true
  
  
  class << self
    def create_daily_challenge(name, start_date, end_date)
      challenge = DailyChallenge.by_name(name).first
      unless challenge
        challenge = DailyChallenge.new(name: name, start_date: start_date + '00:00', end_date: end_date + '18:00')
        challenge.save
      end
    end
  end
  
  def create_match(match, match_date, team_a_score, team_b_score, result)
    match = self.matches.where(match: match).first
    unless match
      match = self.matches.new(match: match, match_date: match_date, team_a_score: team_a_score, team_b_score: team_b_score, result: result, points: 5 )
      match.save
    end
  end
  
end