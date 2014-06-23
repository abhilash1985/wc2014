module HomeHelper
  def last_challenge
    DailyChallenge.last_challenge.last
  end
end
