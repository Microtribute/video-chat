class RemoveFullNameFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :full_name
  end

  def down
    add_column :users, :full_name, :string
  end
end

