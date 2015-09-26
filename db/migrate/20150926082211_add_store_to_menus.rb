class AddStoreToMenus < ActiveRecord::Migration
  def change
    add_reference :menus, :store, index: true, foreign_key: true
  end
end
