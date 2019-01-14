class AddTokboxInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tb_session_id, :string, :limit => 255
    add_column :users, :tb_token, :text
  end
end

=begin
	
ALTER TABLE  `users` ADD  `tb_session_id` VARCHAR( 255 ) NOT NULL ,
ADD  `tb_token` TEXT NOT NULL

=end