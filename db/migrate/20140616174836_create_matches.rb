class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :match
      t.integer :daily_challenge_id
      t.datetime :played_on
      t.integer :team_a_score, :default => 0
      t.integer :team_b_score, :default => 0
      t.string :result
      t.string :points, :default => 0

      t.timestamps
    end
  end
end
