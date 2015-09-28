class AddCaptionTextAndLowResolutionAndThumbnailAndStandardResolutionToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :caption_text, :string
    add_column :menus, :low_resolution, :string
    add_column :menus, :tumbnail, :string
    add_column :menus, :standard_resolution, :string
  end
end
