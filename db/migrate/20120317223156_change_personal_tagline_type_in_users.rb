class ChangePersonalTaglineTypeInUsers < ActiveRecord::Migration
  def up
    change_column :users, :personal_tagline, :text
  end

  def down
    change_column :users, :personal_tagline, :string
  end
end
