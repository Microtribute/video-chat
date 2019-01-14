class AddConsultationTypeToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :consultation_type, :string
  end
end
