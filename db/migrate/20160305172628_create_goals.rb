class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name
      t.text :description
      t.integer :team_id
      t.integer :priority
      t.integer :support
      t.integer :effort

      t.timestamps null: false
    end
  end
end
