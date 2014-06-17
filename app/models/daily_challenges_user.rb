class DailyChallengesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :daily_challenge
  has_many :predictions
end
