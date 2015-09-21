class AuthHashService
  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def find_or_create_user_from_auth_hash
    find_user || create_user
  end

  private

  attr_accessor :auth_hash
  attr_reader :identity

  def find_user
    find_or_create_identity.user
  end

  def create_user
    @user = User.create(external_auth_count: 1)
    @user.identities << identity
    @user
  end

  def find_identity_by_auth_hash
    Identity.find_by(provider: auth_hash['provider'], uid: auth_hash['uid'])
  end

  def create_identity
    @identity = Identity.create(
      provider: auth_hash['provider'],
      uid: auth_hash['uid'],
      name: name,
      nickname: auth_hash['info']['nickname']
    )
  end

  def find_or_create_identity
    find_identity_by_auth_hash || create_identity
  end

  def name
    auth_hash['info']['name'] || auth_hash['info']['nickname']
  end

=begin
adding sns id using update without oauth could be dangerous.
need to add omniauth everytime you switch sns id
also email and password need more login to add and remove

  def find_by_instagram
    user = User.find_by(instagram_username: auth_hash["info"]["nickname"])
    update_provider_info(user)
    user
  end

  def find_by_email
    user = User.find_by(email: auth_hash["info"]["email"])
    update_provider_info(user)
    user
  end


  def update_provider_info(user)
    if user
      user.update_attributes(
        auth_provider: auth_hash["provider"],
        auth_uid: auth_hash["uid"]
      )
    end
  end
=end
end
