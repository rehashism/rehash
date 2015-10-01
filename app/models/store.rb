class Store < ActiveRecord::Base
  belongs_to :user
  has_many :menus, dependent: :delete_all
end
