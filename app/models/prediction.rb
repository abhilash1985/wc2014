class Prediction < ActiveRecord::Base
  # belongs_to :user
  belongs_to :daily_challenges_user
  belongs_to :match
  
  before_save :save_points, :save_result, :save_options, :save_team_scores
  store_accessor :options, :goal_time
  store_accessor :options, :ft_score1, :ft_score2, :ft_result, 
                           :et_score1, :et_score2, :et_result, 
                           :so_score1, :so_score2, :so_result
  
  include SharedMethods
  
  # scope :by_user, lambda { |user| where(:user_id => user) }
  scope :by_match, lambda { |match| where(:match_id => match) }
  scope :by_daily_challenge, lambda { |daily_challenge_id| 
          where("daliy_challenges_users.daily_challenge_id" => daily_challenge_id) 
        }
  scope :by_user, lambda { |user_id| where("daliy_challenges_users.user_id" => user_id) }
  
  def full_score
    "#{team_a_score} - #{team_b_score}"
  end
 
  def save_points
    self.points = calculate_points
  end
  
  def save_result
    self.result = calculate_result
  end
  
  def calculate_points
    goals_for + goals_against + goal_diff_points + winner + options_points.to_i
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
  
  def options_points
    if !self.match.options.blank? && !self.options.blank?
      case self.match.stage
      when 'group'
        0
      when 'knockout'
        (self.options['goal_time'] == self.match.options['goal_time']) ? 2 : 0
      else
        self.match.options.inject(0){|total, value| total += 1 if compare_final_options(value[0], value[1]); total }
      end
    end
  end
  
  def compare_final_options(key, value)
    if key.match(/result/).blank?  
      self.options[key].to_i == value.to_i
    else
      self.options[key] == value
    end
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
