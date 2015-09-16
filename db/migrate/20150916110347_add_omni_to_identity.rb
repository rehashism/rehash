class AddOmniToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :name, :string
    add_column :identities, :provider, :string
    add_column :identities, :uid, :integer
    add_column :identities, :nickname, :string
  end
end
