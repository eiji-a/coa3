class CreateContentsTags < ActiveRecord::Migration
  def self.up
    create_table :contents_tags, :id => false do |t|
      t.integer :content_id
      t.integer :tag_id
    end
  end

  def self.down
    drop_table :contents_tags
  end
end
