require_relative 'lib/rally_extractor'
require_relative 'lib/rally_to_drools_transformer'
require_relative 'lib/drools_formatter'

class BuildDeclarations

  include RallyExtractor
  include RallyToDroolsTransformer
  include DroolsFormatter

  def etl
    type_defs = fetch_type_definitions
    drools_declarations = drools_declarations_from type_defs
    puts format_declarations(drools_declarations)
  end

end

puts BuildDeclarations.new.etl