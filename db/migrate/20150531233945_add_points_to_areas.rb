class AddPointsToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :points, :integer
  end
end
