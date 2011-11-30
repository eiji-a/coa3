class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.string :subject
      t.date :start_date
      t.string :start_time
      t.date :end_date
      t.string :end_time
      t.string :place
      t.integer :content_id

      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
