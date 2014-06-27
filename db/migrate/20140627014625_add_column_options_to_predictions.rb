class AddColumnOptionsToPredictions < ActiveRecord::Migration
  def change
    add_column :predictions, :options, :hstore
  end
end
