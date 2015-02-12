class HomeController < ApplicationController
	def index
		@daily_challenges = ((1..13).to_a << 18).include?(current_user.id) ? DailyChallenge.active_today : [DailyChallenge.last]
		@prediction = Prediction.new
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
		respond_to do |format|
		  flash[:notice] = "Successfully created prediction for match #{@match.match}"
			format.js
		end
	end
	
	def mailer
	end

  def send_mail
    path = ""
    if params[:attachment]
      name = params[:attachment].original_filename
      directory = "public/"
      # create the file path
      path = File.join(directory, name)
      # write the file
      File.open(path, "wb") { |f| f.write(params[:attachment].read) }
    end
    # message = UserMailer.welcome(parameters)  # => Returns a Mail::Message object
    # message.deliver                           # => delivers the email
    # UserMailer.welcome(current_user, params[:email], params[:subject], params[:content], path).deliver
    UserMailer.delay.welcome(current_user, params[:email], params[:subject], params[:content], path)
    respond_to do |format|
      format.js
    end
  end
  
  def recieve_email
    Mail.all.each do |email|
      logger = Logger.new("#{Rails.root.to_s}/log/email.log")
      logger.info("Got an email: #{email}")
      logger.info("Got an email about: #{email.subject}")
      logger.info("Got an email with body: #{email.body}")
    end
  end
  
  def delayed_sample_methods
    @user.activate!(@device)
    # with delayed_job
    @user.delay.activate!(@device)
  end
end
