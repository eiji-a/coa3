class AddDisclosureIdToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :disclosure_id, :integer
  end

  def self.down
    remove_column :contents, :disclosure_id
  end
end
