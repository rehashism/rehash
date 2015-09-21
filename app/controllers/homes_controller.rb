class HomesController < ApplicationController
  def index
    if signed_in?
      @a = Instagram.client(access_token: session[:token]).user_recent_media
    end
  end
end
