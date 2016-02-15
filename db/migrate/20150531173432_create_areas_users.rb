class CreateAreasUsers < ActiveRecord::Migration
  def change
    create_table :areas_users, :id => false do |t|
      t.references :area, :user
    end

    add_index :areas_users, [:area_id, :user_id],
      name: "areas_users_index",
      unique: true
  end
end
