class HomesController < ApplicationController
  def index
    if signed_in?
      @a = Instagram.client(access_token: session[:token]).user_recent_media
    end
  end

  def create
    require 'erb'
    erb_file = File.join(Rails.root + 'app/templates/layout.html.erb')
    html_file = File.basename(erb_file, '.erb') #=>"page.html"
    erb_str = File.read(erb_file)

    @name = "Nyuno"
    renderer = ERB.new(erb_str)
    result = renderer.result()

    system "mkdir #{@name}"
    File.open(@name + '/' + html_file, 'w') do |f|
        f.write(result)
    end
    ####### end generate html file
    #
    ####### TODO

    #system "aws s3 cp #{@name} s3://rehash-dev.com/#{@name} --recursive"
    #system "rm -rf #{@name}"

    redirect_to root_path
  end
end
