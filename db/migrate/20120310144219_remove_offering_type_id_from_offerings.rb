class RemoveOfferingTypeIdFromOfferings < ActiveRecord::Migration
  def up
    remove_column :offerings, :offering_type_id
  end

  def down
  end
end
