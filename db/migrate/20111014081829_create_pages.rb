class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
    t.string   "name"
    t.string   "page_title"
    t.string   "page_header"
    t.text     "content"
    t.boolean  "is_deleted"
    t.timestamps
    end
  end
end
