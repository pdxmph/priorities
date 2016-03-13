class AddRenderedDescriptionToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :rendered_description, :text
  end
end
