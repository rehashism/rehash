class AddEmailAuthToUser < ActiveRecord::Migration
  def change
    add_column :users, :external_auth_count, :integer
  end
end
