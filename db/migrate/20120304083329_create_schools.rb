class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.integer :rank
      t.integer :rank_category

      t.timestamps
    end
  end
end
