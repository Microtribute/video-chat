class AddLawyerIdToOfferings < ActiveRecord::Migration
  def change
    add_column :offerings, :lawyer_id, :integer
  end
end
