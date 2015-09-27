require 'erb'
require 'json'
class PageGenerator
  attr_reader :page_name

  def initialize(current_user)
    @current_user = current_user
    @page_name = @current_user.store.name
  end

  def generate_page
    erb_file = File.join(Rails.root + 'app/templates/layout.html.erb')
    html_file = File.basename(erb_file, '.erb') #=>"page.html"
    erb_str = File.read(erb_file)

    renderer = ERB.new(erb_str)
    result = renderer.result(binding)

    system "mkdir #{@page_name}"
    File.open(@page_name + '/' + html_file, 'w') do |f|
        f.write(result)
    end
  end

  def generate_json
    json_erb_file = File.join(Rails.root + 'app/templates/route53.json.erb')
    json_file = File.basename(json_erb_file, '.erb')
    json_erb_str = File.read(json_erb_file)

    renderer = ERB.new(json_erb_str)
    json_result = renderer.result(binding)

    File.open(@page_name + '/' + json_file, 'w') do |f|
      f.write(json_result)
    end

    generate_s3
  end

  def file_open(file_name)
    erb_file = File.join(Rails.root + "app/templates/#{file_name}")

  end

end
