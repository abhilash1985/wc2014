module HomeHelper
  def last_challenge
    DailyChallenge.last_challenge.last
  end
  
  def weekly_period(daily_challenges)
    "#{daily_challenges.first.end_date.to_date.to_s(:date_format)} - #{daily_challenges.last.end_date.to_date.to_s(:date_format)}"
  end
  
  def match_stage(match)
    match.final_stage? ? 'knock_out' : 'group_stage'
  end
  
  def won_on_options
    { 'ft' => 'Full Time', 'et' => 'Extra Time', 'so' => 'Shootout' }
  end
end
