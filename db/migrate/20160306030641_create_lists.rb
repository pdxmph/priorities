class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name
      t.integer :user_id
      t.text :description
      t.text :rendered_description
      t.boolean :public

      t.timestamps null: false
    end
  end
end
