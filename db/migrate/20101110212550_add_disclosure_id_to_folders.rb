class AddDisclosureIdToFolders < ActiveRecord::Migration
  def self.up
    add_column :folders, :disclosure_id, :integer
  end

  def self.down
    remove_column :folders, :disclosure_id
  end
end
