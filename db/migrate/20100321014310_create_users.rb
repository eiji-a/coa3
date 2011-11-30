class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :userid
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.integer :priv

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
