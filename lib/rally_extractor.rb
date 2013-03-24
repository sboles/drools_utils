require 'rally_api'
require 'highline/import'
require 'yaml'

module RallyExtractor

  def fetch_type_definitions
    rally_context = new_rally_context
    rally_context.find do |q|
      q.type = 'type_definition'
      q.fetch = 'Name,Attributes'
      q.workspace = {'_ref' => rally_context.rally_default_workspace._ref}
    end
  end

  private

  def new_rally_context
    headers = RallyAPI::CustomHttpHeader.new({:vendor => 'RallyExtractor', :name => 'Rules Typedef Declaration Builder', :version => '1'})

    config = {:base_url => 'https://rally1.rallydev.com/slm'}
    config[:username] = rally_config["username"] || ask("Enter Rally Username")
    config[:password] = rally_config["password"] || ask("Enter Rally Password") { |q| q.echo = false }
    config[:workspace] = rally_config["workspace"] || ask("Enter Rally Workspace")
    config[:headers] = headers

    RallyAPI::RallyRestJson.new(config)
  end

  def rally_config
    filename = "#{ENV['HOME']}/.rally_config"
    unless File.exist?(filename)
      return {}
    end
    config = YAML.load(File.open(filename))
    config["user"]
  end

end

