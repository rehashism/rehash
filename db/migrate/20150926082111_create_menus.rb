class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.string :price
      t.string :image_url
      t.text :description

      t.timestamps null: false
    end
  end
end
