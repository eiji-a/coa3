class AddNoticeTimeToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :notice_time, :integer
  end

  def self.down
    remove_column :schedules, :notice_time
  end
end
