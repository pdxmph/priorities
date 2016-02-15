class AddRenderedContentToComment < ActiveRecord::Migration
  def change
    add_column :comments, :rendered_content, :text
  end
end
