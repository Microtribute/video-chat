class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.references :client
      t.integer :lawyer_id
      t.string :sid
      t.string :status
      t.integer :call_duration
      t.string :from
      t.string :to
      t.datetime :start_date
      t.datetime :billing_start_time
      t.datetime :end_date

      t.timestamps
    end
  end
end

