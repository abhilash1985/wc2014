class CreateDailyChallenges < ActiveRecord::Migration
  def change
    create_table :daily_challenges do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
