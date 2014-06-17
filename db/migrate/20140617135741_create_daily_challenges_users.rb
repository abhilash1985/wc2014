class CreateDailyChallengesUsers < ActiveRecord::Migration
  def change
    create_table :daily_challenges_users do |t|
      t.integer :user_id
      t.integer :daily_challenge_id

      t.timestamps
    end
  end
end
