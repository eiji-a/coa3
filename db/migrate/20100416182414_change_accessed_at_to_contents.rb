class ChangeAccessedAtToContents < ActiveRecord::Migration
  def self.up
    change_column :contents, :accessed_at, :timestamp
  end

  def self.down
    change_column :contents, :accessed_at, :time
  end
end
