class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :user_id
      t.text :description
      t.text :rendered_description

      t.timestamps null: false
    end
  end
end
