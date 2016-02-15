class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.integer :priority
      t.string :work
      t.integer :frequency
      t.integer :state

      t.timestamps null: false
    end
  end
end
