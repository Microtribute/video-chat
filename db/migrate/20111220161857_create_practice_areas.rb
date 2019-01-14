class CreatePracticeAreas < ActiveRecord::Migration
  def change
    create_table :practice_areas do |t|
      t.string :name
      t.integer :parent_id, :default => nil

      t.timestamps
    end
  end
end

