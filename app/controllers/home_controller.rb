class HomeController < ApplicationController
  def index
    @daily_challenges = DailyChallenge.active_today
  end
  
  def points_table
    @daily_challenge = DailyChallenge.previous_day.first
    @users = @daily_challenge.users
    @matches = @daily_challenge.matches.order('id')
  end
  
end
