class AddMessageToAppointment < ActiveRecord::Migration
  def change
    add_column(:appointments, :message, :text)
  end
end
