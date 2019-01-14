class CreateAppParameters < ActiveRecord::Migration
  def change
    create_table :app_parameters do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
