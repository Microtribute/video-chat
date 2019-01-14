class AddPersonalTaglineToUsers < ActiveRecord::Migration
  def change
    add_column :users, :personal_tagline, :string
    add_column :users, :bar_ids, :string
  end
end
