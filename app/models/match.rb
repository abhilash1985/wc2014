class Match < ActiveRecord::Base
  belongs_to :daily_challenge
  has_many :predictions, :dependent => :destroy
  # has_many :users, :through => :predictions
  
  before_save :save_points, :save_result, :save_options, :save_team_scores 
  
  after_save :update_predictions
  store_accessor :options, :goal_time
  store_accessor :options, :ft_score1, :ft_score2, :ft_result, 
                           :et_score1, :et_score2, :et_result, 
                           :so_score1, :so_score2, :so_result
  
  include SharedMethods
  
  scope :order_by_game_id, -> { order(:game_id) }
  scope :by_daily_challenge, lambda { |dailiy_challenge_id| where(:daily_challenge_id => dailiy_challenge_id) }
  scope :by_game_id, lambda { |game_id| where(:game_id => game_id) }
  
  validates :game_id, :match, :presence => true, :uniqueness => true
  validates :played_on, :presence => true
  
  def update_predictions
    self.predictions.each { |prediction| prediction.save  }
  end
  
  def total_points_for(user)
    self.predictions.by_user(user).sum(:calculate_points)
  end
  
  def group?
    stage == 'group'
  end
  
  def knockout?
    stage == 'knockout'
  end
  
  def final_stage?
    ['group', 'knockout'].exclude?(stage)
  end
  
  def save_points
    self.points = calculate_points
  end
  
  def calculate_points
    goals_for + goals_against + goal_diff_points + winner + options_points.to_i
  end
  
  def goals_for
    1
  end
  
  def goals_against
    1
  end
  
  def goal_diff_points
    1
  end
  
  def winner
    2
  end
  
  def options_points
    case stage
    when 'group'
      0
    when 'knockout'
      2
    else
      options.keys.count
    end
  end
  
  def save_result
    self.result = calculate_result
  end
  
  def disabled
    'disabled' if daily_challenge.expired?
  end
  
  def column_count
    final_stage? ? 7 : 2
  end
  
  def teams
    self.match.split('Vs')
  end
  
  def team_a_name
    self.teams[0].strip
  end
  
  def team_a_short_name
    team_a_name[0,3].upcase
  end
  
  def team_b_name
    self.teams[1].strip
  end
  
  def team_b_short_name
    team_b_name[0,3].upcase
  end
  
end
