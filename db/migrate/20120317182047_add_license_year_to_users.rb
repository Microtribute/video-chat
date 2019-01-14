class AddLicenseYearToUsers < ActiveRecord::Migration
  def change
    add_column :users, :license_year, :integer
  end
end
