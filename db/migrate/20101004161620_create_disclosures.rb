class CreateDisclosures < ActiveRecord::Migration
  def self.up
    create_table :disclosures do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :disclosures
  end
end
