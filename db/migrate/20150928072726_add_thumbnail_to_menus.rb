class AddThumbnailToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :thumbnail, :string
  end
end
