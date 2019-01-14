class RemovePracticeAreasFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :practice_areas
  end

  def down
    add_column :users, :practice_areas, :text
  end
end
