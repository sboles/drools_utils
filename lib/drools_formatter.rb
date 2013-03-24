require 'erb'

module DroolsFormatter

  def format_declarations(type_defs)
    type_defs.collect do |type_def|
      format_declaration(type_def)
    end.join("\n")
  end

  private

  DECLARATION_TEMPLATE = ERB.new <<DECLARATION
declare <%= type_def[:name] %>
    <%= format_declaration_attributes(type_def) %>
end
DECLARATION

  ATTRIBUTE_TEMPLATE = ERB.new <<ATTRIBUTE
    <%= attribute_def[:name] %> : <%= attribute_def[:type] %>
ATTRIBUTE


  def format_declaration(type_def)
    DECLARATION_TEMPLATE.result(binding)
  end

  def format_declaration_attributes(type_def)
    type_def[:attributes].collect do |attribute_def|
      ATTRIBUTE_TEMPLATE.result(binding)
    end.join.strip
  end

end