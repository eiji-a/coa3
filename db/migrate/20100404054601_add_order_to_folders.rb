class AddOrderToFolders < ActiveRecord::Migration
  def self.up
    add_column :folders, :order, :integer
  end

  def self.down
    remove_column :folders, :order
  end
end
