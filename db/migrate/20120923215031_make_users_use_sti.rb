class MakeUsersUseSti < ActiveRecord::Migration
  def up
    add_column(:users, :type, :string)
    
    User.update_all("user_type = 'Client'", ["user_type = ?", 'CLIENT'])
    User.update_all("user_type = 'Admin'", ["user_type = ?", 'ADMIN'])
    User.update_all("user_type = 'Lawyer'", ["user_type = ?", 'LAWYER'])

    add_index(:users, [:user_type, :id])
  end

  def down
    remove_column(:users, :type)
  end
end
