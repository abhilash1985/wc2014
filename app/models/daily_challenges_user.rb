class DailyChallengesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :daily_challenge
  has_many :predictions
  
  scope :by_daily_challenge, lambda { |daily_challenge| where(:daily_challenge_id => daily_challenge) }
  scope :by_user, lambda { |user| where(:user_id => user) }
  
  def create_prediction(match, team_a_score, team_b_score, result)
    prediction = self.predictions.where(match_id: match).first_or_initialize
    prediction.team_a_score = team_a_score
    prediction.team_b_score = team_b_score
    prediction.result = result
    prediction.save
    prediction
  end
end
