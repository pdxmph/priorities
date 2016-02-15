class ChangeStateToSupport < ActiveRecord::Migration
  def change
    rename_column :areas, :state, :support
  end
end
