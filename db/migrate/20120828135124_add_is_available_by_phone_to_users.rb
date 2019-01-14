class AddIsAvailableByPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_available_by_phone, :boolean, :default => false
    add_index :users, :is_available_by_phone
  end
end
