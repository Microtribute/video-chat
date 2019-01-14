class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :inquiry_id
      t.integer :lawyer_id
      t.integer :amount

      t.timestamps
    end
  end
end
