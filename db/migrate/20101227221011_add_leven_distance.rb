class AddLevenDistance < ActiveRecord::Migration
  def self.up
    add_column :attempts, :distance, :integer
  end

  def self.down
    remove_column :attempts, :distance
  end
end
