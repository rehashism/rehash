class PageGenerator
  attr_reader :page_name

  def initialize(current_user)
    @current_user = current_user
    @page_name = @current_user.store.name
  end

  def make_directory
    system "mkdir #{@page_name}"
  end

  def generate_files
    generate_data_json
    generate_route_json
  end

  private

  def generate_data_json
    file_name = File.join(Rails.root + "builder/_data/menus.json")
    File.open(file_name, 'w') { |f| f.write(menus_to_json) }
  end

  def menus_to_json
    @current_user.store.menus.to_json(only: [:name, :price, :category, :standard_resolution])
  end

  def generate_route_json
    write_file('route53.json')
  end

  def write_file(file_name)
    erb_file = File.join(Rails.root + "app/templates/#{file_name}.erb")
    basic_file = File.basename(erb_file, '.erb')
    erb_str = File.read(erb_file)
    
    renderer = ERB.new(erb_str)
    result = renderer.result(binding)

    File.open(@page_name + '/' + basic_file, 'w') { |f| f.write(result)  }
  end

end
