module OpenapiSdkGenerator
  class Generator
    attr_reader :parser
    
    def initialize(parser)
      @parser = parser
    end
    
    def generate
      raise NotImplementedError, "Subclasses must implement #generate"
    end
    
    def write_to_directory(output_dir)
      raise NotImplementedError, "Subclasses must implement #write_to_directory"
    end
    
    protected
    
    def render_template(template_name, binding_context)
      template_path = File.join(__dir__, 'templates', template_name)
      template = File.read(template_path)
      ERB.new(template, trim_mode: '-').result(binding_context)
    end
    
    def sanitize_name(name)

      # Convert to snake_case and remove special characters
      name.gsub(/[^a-zA-Z0-9_]/, '_').gsub(/_{2,}/, '_').downcase
    end
    
    def camelize(string)
      string.split('_').map(&:capitalize).join
    end
  end
end