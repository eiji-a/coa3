class CreateContentsContents < ActiveRecord::Migration
  def self.up
    create_table :contents_contents, :id => false do |t|
      t.integer :parent_id
      t.integer :child_id
    end
  end

  def self.down
    drop_table :contentes_contents
  end
end
