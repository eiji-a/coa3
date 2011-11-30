class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.integer :user_id
      t.integer :folder_id
      t.string :title
      t.string :mimetype
      t.text :metainfo
      t.string :path
      t.integer :size
      t.integer :storagetype
      t.time :accessed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
