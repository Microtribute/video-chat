class AddFieldsToQuestionStateAndArea < ActiveRecord::Migration
  def change
    add_column :questions, :state_name, :string
    add_column :questions, :practice_area, :string
  end
end
