class AddPaymentStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :payment_status, :string, :default => :unpaid, :after => :is_approved
    add_index :users, :payment_status
  end
end
