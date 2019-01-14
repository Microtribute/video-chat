class CreateFrameyTables < ActiveRecord::Migration
  def self.up
    
  create_table "framey_videos", :force => true do |t|
    t.string   "name"   
    t.integer  "filesize",             :default => 0
    t.float    "duration"    
    t.string   "state"
    t.integer  "views"
    t.string   "data"
    t.string   "flv_url"
    t.string   "mp4_url"
    t.string   "medium_thumbnail_url"
    t.string   "large_thumbnail_url"
    t.string   "small_thumbnail_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  end

  def self.down
    drop_table :framey_videos
  end
end
