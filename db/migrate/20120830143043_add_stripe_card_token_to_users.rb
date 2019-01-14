class AddStripeCardTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_card_token, :string, :after => :stripe_customer_token
  end
end
