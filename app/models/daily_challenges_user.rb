class DailyChallengesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :daily_challenge
  has_many :predictions
  
  scope :by_daily_challenge, lambda { |daily_challenge| where(:daily_challenge_id => daily_challenge) }
  scope :by_user, lambda { |user| where(:user_id => user) }
  
  def self.create_prediction(match, user_id, dc_id, team_a_score, team_b_score, result)
    dcu = DailyChallengesUser.where(daily_challenge_id: dc_id, user_id: user_id).first_or_initialize
    dcu.daily_challenge_id = dc_id
    dcu.user_id = user_id
    dcu.save
    prediction = Prediction.where(match_id: match).first_or_initialize
    prediction.daily_challenges_user_id = dcu.id
    prediction.match_id = match
    prediction.team_a_score = team_a_score.to_i
    prediction.team_b_score = team_b_score.to_i
    prediction.result = result
    prediction.save
  end
  
  def create_prediction(match, team_a_score, team_b_score, options)
    prediction = self.predictions.where(match_id: match).first_or_initialize
    # prediction.match_id = match
    prediction.team_a_score = team_a_score.to_i
    prediction.team_b_score = team_b_score.to_i
    prediction.options = options
    prediction.save
    prediction
  end

end
