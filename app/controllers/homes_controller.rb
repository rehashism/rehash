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

    @name = current_user.identities[0].nickname
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
    #
    generate_s3

    redirect_to root_path
  end

  private

  def generate_s3
    system "aws s3 mb s3://#{@name}.rehashism.com"
    system "aws s3 rm s3://#{@name}.rehashism.com --recursive"
    system %Q[aws s3 sync #{@name} s3://#{@name}.rehashism.com --acl public-read --cache-control "public, max-age=86400"]
    system "aws s3 website s3://#{@name}.rehashism.com --index-document layout.html"
    system "rm -rf #{@name}"

    system %Q[aws route53 change-resource-record-sets --hosted-zone-id ZXXTN8ME7HY7P --change-batch file://app/templates/route53.json]
  end
end
