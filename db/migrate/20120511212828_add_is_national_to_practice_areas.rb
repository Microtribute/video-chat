class AddIsNationalToPracticeAreas < ActiveRecord::Migration
  def change
    add_column :practice_areas, :is_national, :boolean
  end
end
