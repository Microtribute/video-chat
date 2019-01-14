class AddIsClosedToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :is_closed, :boolean
  end
end
