class Match < ActiveRecord::Base
  belongs_to :daily_challenge
  has_many :predictions
end
