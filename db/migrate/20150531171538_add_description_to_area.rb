class AddDescriptionToArea < ActiveRecord::Migration
  def change
    add_column :areas, :description, :text
    add_column :areas, :rendered_description, :text
  end
end
