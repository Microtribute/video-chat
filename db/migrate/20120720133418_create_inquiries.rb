class CreateInquiries < ActiveRecord::Migration
  def up
    create_table :inquiries do |t|
      t.integer :question_id

      t.timestamps
    end
  end

  def down
  end
end
