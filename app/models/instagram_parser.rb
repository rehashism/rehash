class InstagramParser
  attr_reader :client, :user_info, :media_info, :current_user

  def initialize(access_token, current_user)
    @client = Instagram.client(access_token: access_token)
    @user_info = @client.user
    @media_info = @client.user_recent_media
    @current_user = current_user
  end

  def create_menus
    parse_media.each { |media| create_menu(media)  }
  end

  def delete_menus
    store.menus.delete_all
  end

  def parse_media
    @media_info.reduce([]) do |media, medium|
      media << parse_images(medium).merge(parse_caption(medium))
    end
  end


  private

  def create_menu(params)
    store.menus.create(params)
  end

  def store
    @current_user.store
  end

  def parse_caption(medium)
    caption = {}
    if medium.caption
      caption[:caption_text] = medium.caption.text
      caption.merge!(parse_tag(caption[:caption_text]))
    end
    caption
  end

  def parse_tag(caption)
    { price: caption.scan(/\$\d+\.*\d*/)[0].to_s.gsub!(/\$/, ''), category: caption.scan(/##\S*/)[0].to_s.encode('utf-8', 'utf-8').scan(/[[:alnum:]]+/)[0], name: caption.scan(/\!#\S*/)[0].to_s.encode('utf-8', 'utf-8').scan(/[[:alnum:]]+/)[0] }
  end

  def parse_images(medium)
    data = medium.to_hash.slice("images")["images"].deep_symbolize_keys
    data.transform_values { |x| x[:url] }
  end
end
