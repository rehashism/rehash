class User < ActiveRecord::Base
  include Clearance::User

  has_many :identities
  has_one :store

  def external_auth?
    external_auth_count > 0
  end

  private

  def password_optional?
    super || external_auth?
  end

  def email_optional?
    super || external_auth?
  end
end
