class RemoveTumbnailFromMenus < ActiveRecord::Migration
  def change
    remove_column :menus, :tumbnail, :string
  end
end
