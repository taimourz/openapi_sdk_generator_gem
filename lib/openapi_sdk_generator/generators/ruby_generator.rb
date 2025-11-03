module OpenapiSdkGenerator
  module Generators
    class RubyGenerator < Generator
      def generate
        {
          client: generate_client,
          models: generate_models
        }
      end
      
      def write_to_directory(output_dir)
        FileUtils.mkdir_p(output_dir)
        FileUtils.mkdir_p(File.join(output_dir, 'models'))
        
        client_content = generate_client
        File.write(File.join(output_dir, 'client.rb'), client_content)
        
        parser.models.each do |name, model|
          model_content = generate_model(model)
          filename = "#{sanitize_name(name)}.rb"
          File.write(File.join(output_dir, 'models', filename), model_content)
        end
        
        readme_content = generate_readme
        File.write(File.join(output_dir, 'README.md'), readme_content)
      end
      
      private
      
      def generate_client
        render_template('ruby_client.erb', binding)
      end
      
      def generate_models
        parser.models.map do |name, model|
          generate_model(model)
        end
      end
      
      def generate_model(model)
        @current_model = model
        render_template('ruby_model.erb', binding)
      end
      
      def generate_readme
        <<~README
        # #{parser.api_title}
        
        #{parser.api_description}
        
        Version: #{parser.api_version}
        
        ## Installation
        
        Add this to your application's Gemfile:
        ```ruby
        gem 'your_gem_name'
        ```
        
        ## Usage
        ```ruby
        require_relative 'client'
        
        client = APIClient.new('#{parser.base_url}')
        
        # Example usage
        #{parser.endpoints.first ? "# #{parser.endpoints.first[:summary]}" : '# Make API calls'}
        #{parser.endpoints.first ? "# response = client.#{method_name(parser.endpoints.first)}(...)" : ''}
        ```
        
        ## Available Methods
        
        #{parser.endpoints.map { |e| "- `#{method_name(e)}` - #{e[:summary]}" }.join("\n")}
        README
      end
      
      def method_name(endpoint)
        sanitize_name(endpoint[:operation_id])
      end
      
      def ruby_type(openapi_type)
        case openapi_type
        when 'integer' then 'Integer'
        when 'number' then 'Float'
        when 'string' then 'String'
        when 'boolean' then 'Boolean'
        when 'array' then 'Array'
        when 'object' then 'Hash'
        else 'Object'
        end
      end

        # Converts parameters into Ruby method signature
        def format_method_params(params)
        return "" unless params.is_a?(Array) && !params.empty?

        params.map do |p|
            next unless p.is_a?(Hash)

            name = sanitize_name(p[:name].to_s)
            required = p[:required] ? "" : " = nil"
            "#{name}#{required}"
        end.compact.join(", ")
        end

        # /pets/{petId} → /pets/#{pet_id}
        def format_url_path(path, params = [])
        return path unless params.is_a?(Array) && !params.empty?

        params
            .select { |p| p[:location] == "path" } # FIXED HERE
            .reduce(path) do |memo, p|
            ruby_name = sanitize_name(p[:name].to_s)
            memo.gsub("{#{p[:name]}}", "\#{#{ruby_name}}")
            end
        end

        # Converts OpenAPI type to Ruby class (used by templates)
        def format_ruby_type(schema)
        return "Object" if schema.nil?

        case schema[:type]
        when "integer" then "Integer"
        when "number"  then "Float"
        when "string"  then "String"
        when "boolean" then "Boolean"
        when "array"   then "Array"
        when "object"  then "Hash"
        else
            if schema.is_a?(Hash) && schema["$ref"]
            sanitize_name(schema["$ref"].split('/').last)
            else
            "Object"
            end
        end
        end



    end
  end
end