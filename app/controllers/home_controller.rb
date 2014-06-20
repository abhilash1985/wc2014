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
  	DailyChallengesUser.create_prediction(params[:match_id],current_user.id, params[:daily_challenge_id], params[:team_a_score], params[:team_b_score], params[:result])
		respond_to do |format|
			format.js
		end
		@id =  "f#{params[:match_id]}"
	end

end
