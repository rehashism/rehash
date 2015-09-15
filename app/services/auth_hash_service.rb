class AuthHashService
  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def find_or_create_user_from_auth_hash
    find_by_auth_hash ||
      find_by_instagram ||
      find_by_email ||
      create_user
  end

  private

  attr_accessor :auth_hash

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

  def find_by_auth_hash
    User.find_by(auth_provider: auth_hash['provider'], auth_uid: auth_hash['uid'])
  end

  def update_provider_info(user)
    if user
      user.update_attributes(
        auth_provider: auth_hash["provider"],
        auth_uid: auth_hash["uid"]
      )
    end
  end

  def create_user
    User.create(
      auth_provider: auth_hash['provider'],
      auth_uid: auth_hash['uid'],
      name: name,
      email: auth_hash['info']['email'],
      instagram_username: auth_hash['info']['nickname']
    )
  end

  def name
    auth_hash['info']['name'] || auth_hash['info']['nickname']
  end

end
