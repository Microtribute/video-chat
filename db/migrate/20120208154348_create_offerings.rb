class CreateOfferings < ActiveRecord::Migration
  def change
    create_table :offerings do |t|
      t.string :name
      t.text :description
      t.float :fee, default: 0.0
      t.integer :offering_type_id

      t.timestamps
    end
  end
end
