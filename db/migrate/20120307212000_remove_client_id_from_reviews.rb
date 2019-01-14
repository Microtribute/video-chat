class RemoveClientIdFromReviews < ActiveRecord::Migration
  def up
    remove_column :reviews, :client_id
    remove_column :reviews, :lawyer_id
  end

  def down
  end
end
