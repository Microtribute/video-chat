class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :client_id,       :null =>false
      t.integer :lawyer_id,       :null =>false
      t.integer :conversation_id, :null =>false      
      t.text :content

      t.timestamps
    end
  end
  
end
