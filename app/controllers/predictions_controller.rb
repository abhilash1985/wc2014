class PredictionsController < ApplicationController
  before_action :set_prediction, only: [:show, :edit, :update, :destroy]

  # GET /predictions
  # GET /predictions.json
  def index
    @daily_challenge = DailyChallenge.today.first # DailyChallenge.today.first
    @end_time = Date.today.to_s + ' 17:30'
    @users = current_user.has_predictions_for_challenge?(@daily_challenge) ? @daily_challenge.users : [current_user]
    @matches = @daily_challenge.matches.order('id')
  end

  # GET /predictions/1
  # GET /predictions/1.json
  def show
  end

  # GET /predictions/new
  def new
    @prediction = Prediction.new
  end

  # GET /predictions/1/edit
  def edit
  end

  # POST /predictions
  # POST /predictions.json
  def create

  end

  # PATCH/PUT /predictions/1
  # PATCH/PUT /predictions/1.json
  def update
    respond_to do |format|
      if @prediction.update(prediction_params)
        format.html { redirect_to @prediction, notice: 'Prediction was successfully updated.' }
        format.json { render :show, status: :ok, location: @prediction }
      else
        format.html { render :edit }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /predictions/1
  # DELETE /predictions/1.json
  def destroy
    @prediction.destroy
    respond_to do |format|
      format.html { redirect_to predictions_url, notice: 'Prediction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prediction
      @prediction = Prediction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prediction_params
      params.require(:prediction).permit(:daily_challenges_user_id, :match_id, :team_a_score, :team_b_score, :result)
    end
end
