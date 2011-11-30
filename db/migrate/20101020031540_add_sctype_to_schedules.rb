class AddSctypeToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :sctype, :integer
  end

  def self.down
    remove_column :schedules, :sctype
  end
end
