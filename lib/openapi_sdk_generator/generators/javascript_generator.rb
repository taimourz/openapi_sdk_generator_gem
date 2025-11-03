module OpenapiSdkGenerator
  module Generators
    class JavascriptGenerator < Generator
      def generate
        {
          client: generate_client
        }
      end
      
      def write_to_directory(output_dir)
        FileUtils.mkdir_p(output_dir)
        
        
        client_content = generate_client
        File.write(File.join(output_dir, 'client.js'), client_content)
        
        package_json = generate_package_json
        File.write(File.join(output_dir, 'package.json'), package_json)
        
        readme_content = generate_readme
        File.write(File.join(output_dir, 'README.md'), readme_content)
      end
      
      private


        def generate_client
        render_template('javascript_client.erb', binding)
        end

        def format_js_params(endpoint)
        return "" unless endpoint[:parameters]

        endpoint[:parameters].map { |p| sanitize_name(p[:name]) }.join(", ")
        end      

      def generate_client
        render_template('javascript_client.erb', binding)
      end
      
      def generate_package_json
        {
          name: sanitize_name(parser.api_title).tr('_', '-'),
          version: parser.api_version,
          description: parser.api_description,
          main: "client.js",
          scripts: {
            test: "echo \"Error: no test specified\" && exit 1"
          },
          keywords: ["api", "client", "sdk"],
          author: "",
          license: "MIT"
        }.to_json
      end
      
      def generate_readme
        <<~README
        # #{parser.api_title}
        
        #{parser.api_description}
        
        Version: #{parser.api_version}
        
        ## Installation
```bash

npm install

## Usage
```javascript

const APIClient = require('./client');


// Example usage
    #{parser.endpoints.first ? "// #{parser.endpoints.first[:summary]}" : '// Make API calls'}
    #{parser.endpoints.first ? "// const response = await client.#{js_method_name(parser.endpoints.first)}(...);" : ''}


## Available Methods
        
        #{parser.endpoints.map { |e| "- `#{js_method_name(e)}()` - #{e[:summary]}" }.join("\n")}
        README
      end
            
      def js_method_name(endpoint)
      op = endpoint[:operation_id] || "#{endpoint[:method]}_#{endpoint[:path]}"
      parts = sanitize_name(op).split('_')
      parts.first + parts[1..].map(&:capitalize).join
      end
      
      
      def js_type(openapi_type)
        case openapi_type
        when 'integer', 'number' then 'number'
        when 'string' then 'string'
        when 'boolean' then 'boolean'
        when 'array' then 'array'
        when 'object' then 'object'
        else 'any'
        end
      end
    end
  end
end    