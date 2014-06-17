class RenameColumnUserIdInPredictions < ActiveRecord::Migration
  def change
    rename_column :predictions, :user_id, :daily_challenges_user_id
  end
end
