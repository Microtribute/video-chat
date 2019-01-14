class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :lawyer_id
      t.datetime :time
      t.string :contact_number
      t.string :appointment_type, :default => "phone"

      t.timestamps
    end
  end
end
