class RemoveFirstNameFromCardDetail < ActiveRecord::Migration
  def up
    #remove_column :card_details, :first_name
    #remove_column :card_details, :last_name
    #remove_column :card_details, :street_address
    #remove_column :card_details, :city
    #remove_column :card_details, :state
    #remove_column :card_details, :postal_code
    #remove_column :card_details, :country
  end

  def down
    add_column :card_details, :first_name, :string
    add_column :card_details, :last_name, :string
    add_column :card_details, :street_address, :string
    add_column :card_details, :city, :string
    add_column :card_details, :state, :string
    add_column :card_details, :postal_code, :string
    add_column :card_details, :country, :string
  end
end

