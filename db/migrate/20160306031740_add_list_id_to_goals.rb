class AddListIdToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :list_id, :integer
  end
end
