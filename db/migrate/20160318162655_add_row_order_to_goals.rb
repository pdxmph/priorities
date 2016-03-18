class AddRowOrderToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :row_order, :integer
  end
end
