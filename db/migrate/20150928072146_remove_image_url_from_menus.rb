class RemoveImageUrlFromMenus < ActiveRecord::Migration
  def change
    remove_column :menus, :image_url, :string
  end
end
