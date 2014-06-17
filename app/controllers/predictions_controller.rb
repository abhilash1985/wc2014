class HomeController < ApplicationController
  def index
    @daily_challenges = DailyChallenge.active_today
  end
  
end
