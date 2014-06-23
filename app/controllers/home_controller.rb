class HomeController < ApplicationController
	def index
		@daily_challenges = DailyChallenge.active_today
    # @id = get_id
  end
  
  def points_table
    @daily_challenge = DailyChallenge.today.first
    @users = @daily_challenge.users
    @matches = @daily_challenge.matches.order('id')
  end

  def create_user_prediction		
    match = Match.find params[:match_id]
    @prediction = current_user.create_prediction(match, params[:team_a_score], params[:team_b_score], params[:result])
  	# DailyChallengesUser.create_prediction(params[:match_id],current_user.id, params[:daily_challenge_id], params[:team_a_score], params[:team_b_score], params[:result])
		@id = "f#{params[:match_id]}"
		respond_to do |format|
			format.js
		end
	end

end
