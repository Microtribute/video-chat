class ChangeIsClosedDefaultInInquiries < ActiveRecord::Migration
  def up
    change_column_default :inquiries, :is_closed, false
  end

  def down
  end
end
