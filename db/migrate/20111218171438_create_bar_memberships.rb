class CreateBarMemberships < ActiveRecord::Migration
  def change
    create_table :bar_memberships do |t|
      t.references :lawyer
      t.string :bar_id
      t.integer :state_id
      t.timestamps
    end
  end
end

