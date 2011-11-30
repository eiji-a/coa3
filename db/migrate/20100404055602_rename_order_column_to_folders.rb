class RenameOrderColumnToFolders < ActiveRecord::Migration
  def self.up
    rename_column :folders, :order, :sequence
  end

  def self.down
    rename_column :folders, :sequence, :order
  end
end
