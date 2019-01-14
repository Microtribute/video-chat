class AddLawyerIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :lawyer_id, :integer
  end
end
