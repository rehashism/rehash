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
    result = renderer.result(binding)
    #need to figure out if result can pass @name first then try json

    system "mkdir #{@name}"
    File.open(@name + '/' + html_file, 'w') do |f|
        f.write(result)
    end

    ####### end generate html file
    require 'json'
    json_erb_file = File.join(Rails.root + 'app/templates/route53.json.erb')
    json_file = File.basename(json_erb_file, '.erb')
    json_erb_str = File.read(json_erb_file)

    renderer = ERB.new(json_erb_str)
    json_result = renderer.result(binding)

    File.open(@name + '/' + json_file, 'w') do |f|
      f.write(json_result)
    end

    generate_s3

    redirect_to root_path
  end

  private

  def generate_s3
    system "aws s3 mb s3://#{@name}.rehashism.com"
    system "aws s3 rm s3://#{@name}.rehashism.com --recursive"
    system %Q[aws s3 sync #{@name} s3://#{@name}.rehashism.com --acl public-read --cache-control "public, max-age=86400"]
    system "aws s3 website s3://#{@name}.rehashism.com --index-document layout.html"

    system %Q[aws route53 change-resource-record-sets --hosted-zone-id ZXXTN8ME7HY7P --change-batch file://#{@name}/route53.json]

    system "rm -rf #{@name}"
  end
end
