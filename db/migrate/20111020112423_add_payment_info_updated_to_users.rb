class AddPaymentInfoUpdatedToUsers < ActiveRecord::Migration

  def change
    add_column :users, :has_payment_info, :boolean, :default =>false
  end
  

end
