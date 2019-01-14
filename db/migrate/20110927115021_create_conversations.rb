class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :client_id,       :null =>false
      t.integer :lawyer_id,       :null =>false
      t.datetime :start_date,     :null =>false
      t.datetime :end_date,       :null =>false
      t.integer :billable_time
      t.float :lawyer_rate
      t.float :billed_amount,     :default =>0.0
      t.boolean :paid_to_lawyer,  :default =>true

      t.timestamps
    end
  end
end
