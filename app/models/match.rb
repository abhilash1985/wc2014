class Match < ActiveRecord::Base
  belongs_to :daily_challenge
  has_many :predictions, :dependent => :destroy
  # has_many :users, :through => :predictions
  
  after_save :update_predictions
  store_accessor :options, :goal_time
  
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
end
