class RenameLawyerIdInOfferings < ActiveRecord::Migration
  def up
    rename_column :offerings, :lawyer_id, :user_id
  end

  def down
    rename_column :offerings, :user_id, :lawyer_id
  end
end
