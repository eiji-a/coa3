class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table :grants do |t|
      t.integer :user_id
      t.integer :disclosure_id
      t.integer :privilege

      t.timestamps
    end
  end

  def self.down
    drop_table :grants
  end
end
