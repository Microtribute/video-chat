class AddCreatorIdToFrameyVideos < ActiveRecord::Migration
  def change
    add_column :framey_videos, :creator_id, :integer
  end
end
