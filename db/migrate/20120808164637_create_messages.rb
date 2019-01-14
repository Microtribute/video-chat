class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :client_id
      t.integer :lawyer_id

      t.timestamps
    end
  end
end
