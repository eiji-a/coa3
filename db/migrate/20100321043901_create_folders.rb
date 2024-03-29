class CreateFolders < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
      t.string :name
      t.integer :list_flag
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :folders
  end
end
