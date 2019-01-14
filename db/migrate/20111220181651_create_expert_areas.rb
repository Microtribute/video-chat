class CreateExpertAreas < ActiveRecord::Migration
  def change
    create_table :expert_areas do |t|
      t.integer :lawyer_id
      t.integer :practice_area_id

      t.timestamps
    end
  end
end
