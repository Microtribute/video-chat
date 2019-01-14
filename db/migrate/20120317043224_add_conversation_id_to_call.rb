class AddConversationIdToCall < ActiveRecord::Migration
  def change
    add_column :calls, :conversation_id, :integer
  end
end

