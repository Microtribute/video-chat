class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :body
      t.integer :user_id
      t.string :type

      t.timestamps
    end
  end
end
