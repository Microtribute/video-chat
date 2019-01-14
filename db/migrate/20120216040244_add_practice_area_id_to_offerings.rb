class AddPracticeAreaIdToOfferings < ActiveRecord::Migration
  def change
    add_column :offerings, :practice_area_id, :integer
  end
end
