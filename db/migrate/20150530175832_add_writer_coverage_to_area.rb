class AddWriterCoverageToArea < ActiveRecord::Migration
  def change
    add_column :areas, :writer_coverage, :integer
  end
end
