class AddDisclosureIdToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :disclosure_id, :integer
  end

  def self.down
    remove_column :tags, :disclosure_id
  end
end
