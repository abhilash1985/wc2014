class HomeController < ApplicationController
	def index
		@daily_challenges = DailyChallenge.active_today
		@prediction = Prediction.new
    # @id = get_id
  end
  
  def points_table
    @daily_challenge = DailyChallenge.last_challenge.last #last_challenge
    @users = @daily_challenge.users
    @matches = @daily_challenge.matches.order('id')
  end
  
  def weekly_points_table
    @daily_challenges = (params[:status] == 'all') ? DailyChallenge.not_today : DailyChallenge.weekly.not_today
    @period = 'Weekly ' unless params[:status] == 'all'
    @users = User.all
  end

  def create_user_prediction
    index		
    @match = Match.find params[:match_id]
    options = params
    ['commit', 'action', 'utf8', 'controller'].each { |col|
      options.delete(col)
    }
    @prediction = current_user.create_prediction(@match, params[:team_a_score], params[:team_b_score], options)
  	# DailyChallengesUser.create_prediction(params[:match_id],current_user.id, params[:daily_challenge_id], params[:team_a_score], params[:team_b_score], params[:result])
		@id = "match#{@match.game_id}"
		
		# partial_path = render "/home/football/match_details", :m => @match, :current_user => current_user, :dc_today => !match.daily_challenge
		
		respond_to do |format|
		  flash[:notice] = "Successfully created prediction for match #{@match.match}" 
			format.js
		end
	end

end
