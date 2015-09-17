class HomesController < ApplicationController
  def index
    @a = Instagram.client(access_token: session[:token]).user_recent_media
  end
end
