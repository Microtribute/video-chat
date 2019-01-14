class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.text :query
      t.references :user, :null => true   
      t.integer :count, :default => 0

      t.timestamps
    end
    add_index :searches, :user_id
  end
end
