class HomesController < ApplicationController
  def index
    if signed_in?
      @a = Instagram.client(access_token: session[:token]).user_recent_media
    end
  end

  def create
    PageTasker.new(session[:token], current_user).generate_or_refresh_rehash(params[:type])
    redirect_to root_path
  end

end
