class RemoveBarMembershipsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :bar_memberships
  end

  def down
    add_column :users, :bar_memberships, :string
  end
end
