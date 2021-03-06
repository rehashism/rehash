class PageTasker
  def initialize(access_token, current_user)
    @generator = PageGenerator.new(current_user)
    @parser = InstagramParser.new(access_token, current_user)
  end

  def first_generate_rehash
    generate_rehash
  end

  def refresh_rehash
    @parser.delete_menus
    generate_rehash
  end

  def generate_or_refresh_rehash(type)
    if type.eql? "first"
      first_generate_rehash
    elsif type.eql? "refresh"
      refresh_rehash
    else
      raise "type error"
    end
  end

  private
  attr_reader :generator, :parser

  def generate_rehash
    @generator.make_directory
    @parser.create_menus
    @generator.generate_files
    generate_s3(@generator.page_name)
  end

  def generate_s3(page_name)
    temp_env = ENV["BUNDLE_GEMFILE"]
    ENV["BUNDLE_GEMFILE"] = "/home/oiojin831/workspaces/rails/rehash/sample-rehash/Gemfile"
    Dir.chdir "sample-rehash"
    system "bundle exec middleman build --verbose"
    Dir.chdir ".."
    ENV["BUNDLE_GEMFILE"] = temp_env

    system "aws s3 mb s3://#{page_name}.rehashism.com"
    system "aws s3 rm s3://#{page_name}.rehashism.com --recursive"
    system %Q[aws s3 sync sample-rehash/build s3://#{page_name}.rehashism.com --acl public-read --cache-control "public, max-age=86400"]
    system "aws s3 website s3://#{page_name}.rehashism.com --index-document index.html"

    system %Q[aws route53 change-resource-record-sets --hosted-zone-id ZXXTN8ME7HY7P --change-batch file://#{page_name}/route53.json]

    system "rm -rf #{@generator.page_name}"
    system "rm -rf sample-rehash/build"
    system "rm -r sample-rehash/data/*"
  end
end
