class AddFreeConsultationDurationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :free_consultation_duration, :integer
  end
end
