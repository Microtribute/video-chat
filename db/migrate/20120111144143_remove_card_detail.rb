class RemoveCardDetail < ActiveRecord::Migration
  def up
    #drop_table(CardDetail)
    add_column :users, :stripe_customer_token, :string
  end

  def down
    create_table :card_details do |t|
      t.references :user
      t.string :card_type
      t.string :card_number
      t.string :expire_month
      t.string :expire_year
      t.string :card_verification
      t.timestamps
    end
    remove_column :users, :stripe_customer_token
  end
end

