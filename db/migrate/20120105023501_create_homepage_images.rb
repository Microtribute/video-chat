class CreateHomepageImages < ActiveRecord::Migration
  def change
    create_table :homepage_images do |t|
      t.references :lawyer
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size

      t.timestamps
    end
  end
end

