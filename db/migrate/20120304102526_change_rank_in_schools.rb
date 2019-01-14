class ChangeRankInSchools < ActiveRecord::Migration
  def up
    change_column :schools, :rank, :string
  end

  def down
    change_column :schools, :rank, :integer
  end
end
