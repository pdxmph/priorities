class AddJiraNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :jira_name, :string
  end
end
