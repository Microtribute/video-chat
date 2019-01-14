class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :full_name
      t.string  :email
      t.string  :hashed_password
      t.string  :address
      t.string  :skype
      t.float   :balance,         :default =>0.0
      t.boolean :is_online,       :default =>false
      t.boolean :is_busy,         :default =>false
      t.datetime :last_login
      t.datetime :last_online
      t.string  :user_type,       :null =>false     
      t.boolean :is_approved,     :default =>false

      t.text    :bar_memberships      
      t.text    :undergraduate_school
      t.text    :law_school
      t.text    :alma_maters
      t.text    :practice_areas
      t.string  :law_firm
      t.float   :rate,            :default =>0.0
      t.string  :payment_email
      
      t.timestamps
    end
  end
end
