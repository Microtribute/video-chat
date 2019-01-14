class AddYelpBusinessIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :yelp_business_id, :string
  end
end
