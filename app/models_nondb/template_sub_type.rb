class TemplateSubType
  attr_accessor :template_type, :name
  
  def initialize(name, template_type)
    @name = name
    @template_type = template_type
  end
end