class AddChargedStatusToConversation < ActiveRecord::Migration

  def change
    add_column :conversations, :has_been_charged, :boolean, :default =>false
    add_column :conversations, :payment_params, :text
  end
  
end
