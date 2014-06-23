class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
   
  attr_accessor :current_password
         
  has_many :daily_challenges_users, :dependent => :destroy
  has_many :predictions, through: :daily_challenges_users
  has_many :matches, :through => :predictions
  has_many :daily_challenges, through: :daily_challenges_users
         
  def show_name
    full_name.blank? ? show_email : full_name
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def show_email
    email.split('@')[0]
  end
  
  def current_admin
    current_user && current_user.is_admin
  end
  
  def create_prediction(match, team_a_score, team_b_score, result, points = 0)
    # DailyChallengesUser
    daily_challenge = match.try(:daily_challenge)
    daily_challenges_user = self.create_daily_challenge(daily_challenge) if daily_challenge
    prediction = daily_challenges_user.create_prediction(match, team_a_score, team_b_score, result) if match && daily_challenges_user
    # daily_challenges_user.create_prediction(match, team_a_score, team_b_score, result) if match && daily_challenges_user
  end
  
  def points_by_challenge
    daily_challenges.inject({}){ |hash, daily_challenge| 
      hash[daily_challenge.try(:id)] = points_by_matches(daily_challenge).values.sum rescue 0; 
      hash 
    }
  end
  
  def points_by_matches(daily_challenge = nil)
    matches = self.matches.by_scoped(:daily_challenge_id, daily_challenge)
    matches.inject({}){ |hash, match| hash[match.try(:id)] = total_points_for_match(match); hash }
  end
  
  def total_points_for_match(match)
    # predictions_for(daily_challenge)
  end
  
  def total_points_for_challenge(daily_challenge)
    predictions_for(daily_challenge).inject(0){|a, value| a += value.points.to_i }
  end
  
  def total_percentage_for_challenge(daily_challenge)
    points = BigDecimal.new total_points_for_challenge(daily_challenge)
    total_points = BigDecimal.new daily_challenge.total_points
    total_points == 0 ? 0 : (points/total_points * 100).round(2)
  end
  
  def total_score_predictions(daily_challenge)
    predictions_for(daily_challenge).inject(0){|total, prediction| total += prediction.correct_score_count.to_i }
  end

  def total_winner_predictions(daily_challenge)
    predictions_for(daily_challenge).inject(0){|total, prediction| total += prediction.correct_winner_count.to_i }
  end
  
  def total_points
    self.predictions.inject(0){|a, value| a += value.calculate_points.to_i }
  end
  
  def total_played
    daily_challenges.count
  end
  
  def score_count
    self.predictions.sum(:correct_score_count)
  end
  
  def winner_count
    self.predictions.sum(:correct_winner_count)
  end
  
  class << self
    def create_user(first_name, email)
      user = User.where(:email => email).first
      unless user
        user = User.new(:email => email, :first_name => first_name, :password => "#{first_name}12345", :password_confirmation => "#{first_name}12345")
        user.save!
      end
      user
    end
  end
  
  def create_daily_challenge(daily_challenge)
    daily_challenges_user = self.daily_challenges_users.by_daily_challenge(daily_challenge).first_or_initialize
    daily_challenges_user.save
    daily_challenges_user
  end
  
  def predictions_for(daily_challenge)
    predictions.where("daily_challenges_users.daily_challenge_id" => daily_challenge).order('match_id')
  end
  
  def has_predictions_for_match?(match)
    not predictions_for_match(match).blank?
  end
  
  def predictions_for_match(match)
    predictions.by_match(match).first
  end
end
