class AddColumnStageToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :stage, :string, :default => 'group'
    add_index :matches, :stage
  end
end
