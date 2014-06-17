class DailyChallenge < ActiveRecord::Base
  has_many :matches
  
  scope :active, lambda { where("end_date >= ?", Date.today) }
  scope :active_today, lambda { where("'#{Date.today.to_s} 09:00:00' between start_date and end_date" ) }
end