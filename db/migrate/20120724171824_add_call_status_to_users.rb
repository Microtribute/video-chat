class AddCallStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :call_status, :string, :limit => 50
  end
end

=begin
	
ALTER TABLE  `users` ADD  `call_status` VARCHAR( 50 ) NOT NULL

=end