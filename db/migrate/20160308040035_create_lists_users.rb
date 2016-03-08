class CreateListsUsers < ActiveRecord::Migration
  def change
    create_table :lists_users, :id => false do |t|
      t.references :list, :user
    end

    add_index :lists_users, [:list_id, :user_id],
      name: "lists_users_index",
      unique: true
  end
end
