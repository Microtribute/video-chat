class AddLawdingoChargeToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :lawdingo_charge, :float
  end
end
