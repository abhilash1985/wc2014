class AddColumnOptionsToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :options, :hstore
  end
end
