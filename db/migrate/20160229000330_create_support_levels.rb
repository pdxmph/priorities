class CreateSupportLevels < ActiveRecord::Migration
  def change
    create_table :support_levels do |t|
      t.integer :scrum_id
      t.integer :services_id
      t.integer :level

      t.timestamps null: false
    end
  end
end
