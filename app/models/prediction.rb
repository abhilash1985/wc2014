class Prediction < ActiveRecord::Base
  # belongs_to :user
  belongs_to :daily_challenges_user
  belongs_to :match
  
  # after_save :save_points
  
  include SharedMethods
  
  # scope :by_user, lambda { |user| where(:user_id => user) }
  scope :by_match, lambda { |match| where(:match_id => match) }
  
  def save_prediction
  end

  def save_points
    self.points = calculate_points
    self.save
  end
  
  def calculate_points
    goals_for + goals_againts + goal_diff_points + winner
  end
  
  def goals_for
    self.compare('team_a_score') ? 1 : 0
  end
  
  def goals_against
    self.compare('team_b_score') ? 1 : 0
  end
  
  def compare(column)
    self.send(column) == self.match.send(column)
  end
  
  def goal_diff_points
    self.compare('goal_difference') ? 1 : 0
  end
  
  def winner
    self.compare('result') ? 2 : 0
  end
  
  def correct_score_count
    self.correct_score? ? 1 : 0
  end
  
  def correct_score?
    self.compare('team_a_score') && self.compare('team_b_score')
  end
  
  def correct_winner_count
    self.compare('result') ? 1 : 0
  end
  
end
