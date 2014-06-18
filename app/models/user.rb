class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :daily_challenges_users
  has_many :predictions, through: :daily_challenges_users
  has_many :matches, :through => :predictions
  has_many :daily_challenges, through: :daily_challenges_users
         
  def show_name
    full_name.blank? ? email : full_name
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def current_admin
    current_user && current_user.is_admin
  end
  
  def create_prediction(match, team_a_score, team_b_score, result, points = 0)
    daily_challenge = match.try(:daily_challenge)
    daily_challenges_user = self.create_daily_challenge(daily_challenge) if daily_challenge
    daily_challenges_user.create_prediction(match, team_a_score, team_b_score, result) if match && daily_challenges_user
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
    self.predictions.by_match(match).sum(:calculate_points)
  end
  
  def total_points
    self.predictions.sum(:calculate_points)
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
  
end
