class Match < ActiveRecord::Base
  belongs_to :daily_challenge
  has_many :predictions
  # has_many :users, :through => :predictions
  
  after_save :update_predictions
  
  include SharedMethods
  
  scope :by_daily_challenge, lambda { |dailiy_challenge_id| where(:daily_challenge_id => dailiy_challenge_id) }
  
  validates :game_id, :match, :played_on, :presence => true, :uniqueness => true
  
  def update_predictions
    self.predictions.each { |prediction| prediction.save  }
  end
  
  def total_points_for(user)
    self.predictions.by_user(user).sum(:calculate_points)
  end
end
