class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.integer :user_id
      t.integer :match_id
      t.integer :team_a_score, :default => 0
      t.integer :team_b_score, :default => 0
      t.string :result
      t.string :points, :default => 0

      t.timestamps
    end
  end
end
