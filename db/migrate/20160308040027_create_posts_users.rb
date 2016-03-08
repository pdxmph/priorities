class CreatePostsUsers < ActiveRecord::Migration
  def change
    create_table :posts_users, :id => false do |t|
      t.references :post, :user
    end

    add_index :posts_users, [:post_id, :user_id],
      name: "posts_users_index",
      unique: true
  end
end
