json.array!(@predictions) do |prediction|
  json.extract! prediction, :id, :daily_challenges_user_id, :match_id, :team_a_score, :team_b_score, :result
  json.url prediction_url(prediction, format: :json)
end
