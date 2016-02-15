class AddTeamIdToArea < ActiveRecord::Migration
  def change
    add_column :areas, :team_id, :integer
  end
end
