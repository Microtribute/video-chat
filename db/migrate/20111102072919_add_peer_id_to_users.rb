class AddPeerIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :peer_id, :string, :default => "0"
  end
end

