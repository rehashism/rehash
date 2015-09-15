class AddOmniauthToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :auth_provider, :string
    add_column :users, :auth_uid, :integer
    add_column :users, :instagram_username, :string
  end
end
