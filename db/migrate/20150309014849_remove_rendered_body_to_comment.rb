class RemoveRenderedBodyToComment < ActiveRecord::Migration
  def change
    remove_column :comments, :rendered_body, :text
  end
end
