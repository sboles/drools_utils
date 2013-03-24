require 'active_support/inflector'

module RallyToDroolsTransformer

  def drools_declarations_from(type_defs)
    type_defs.collect do |type_def|
      drools_declaration_from(type_def)
    end
  end

  private

  VALID_TYPES = %w(STRING BOOLEAN WEB_LINK DECIMAL TEXT INTEGER QUANTITY DATE)

  TYPES = {'STRING' => 'String',
           'BOOLEAN' => 'Boolean',
           'WEB_LINK' => 'String',
           'DECIMAL' => 'Double',
           'TEXT' => 'String',
           'INTEGER' => 'Integer',
           'QUANTITY' => 'Integer',
           'DATE' => 'Date'}

  def drools_declaration_from(type_def)
    {:name => drools_type_def_name(type_def.Name),
     :attributes => drools_declaration_attributes_from(type_def)}
  end

  def drools_declaration_attributes_from(type_def)
    attributes = [{:name => "_ref", :type => "String"},
                  {:name => "_type", :type => "String"}]
    attributes + selected_type_def_attributes(type_def.Attributes).collect do |attribute_def|
      {:name => drools_attribute_def_name(attribute_def.Name),
       :type => drools_type(attribute_def.AttributeType)}
    end
  end

  def selected_type_def_attributes(attribute_defs)
    attribute_defs.select do |attribute_def|
      convertible_attribute_def?(attribute_def.AttributeType)
    end
  end

  def drools_type_def_name(type_def_name)
    ActiveSupport::Inflector.camelize(type_def_name.delete(' '))
  end

  def drools_attribute_def_name(attribute_def_name)
    ActiveSupport::Inflector.camelize(attribute_def_name.delete(' '), false)
  end

  def drools_type(type)
    TYPES[type]
  end

  def convertible_attribute_def?(type)
    VALID_TYPES.include?(type)
  end

end