class AddRenderedBodyToComment < ActiveRecord::Migration
  def change
    add_column :comments, :rendered_body, :text
  end
end
