class InstagramParser
  attr_reader :client, :user_info, :media_info, :current_user

  def initialize(access_token, current_user)
    @client = Instagram.client(access_token: access_token)
    @user_info = @client.user
    @media_info = @client.recent_media
    @current_user = current_user
  end

  def create_menus
    parse_media.each { |media| create_menu(media)  }
  end

  def delete_menus
    store.menus.destroy_all
  end

  def parse_media

  end

  def refresh_menus
    delete_menus
    create_menus
  end


  private

  def create_menu(params)
    store.menus.create(params)
  end

  def store
    @current_user.store
  end
end
