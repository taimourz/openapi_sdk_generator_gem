module OpenapiSdkGenerator
  class Parser
    attr_reader :spec, :api_info, :base_url, :endpoints, :models
    
    def initialize(file_path)
      @file_path = file_path
      @spec = load_spec
      @endpoints = []
      @models = {}
      @api_info = {}
      parse_spec
    end
    
    def api_title
      @api_info[:title]
    end
    
    def api_version
      @api_info[:version]
    end
    
    def api_description
      @api_info[:description]
    end
    
    private
    
    def load_spec
      content = File.read(@file_path)
      if @file_path.end_with?('.json')
        JSON.parse(content)
      elsif @file_path.end_with?('.yaml', '.yml')
        YAML.load(content)
      else
        raise Error, "Unsupported file format. Use .json, .yaml, or .yml"
      end
    rescue => e
      raise Error, "Failed to parse OpenAPI spec: #{e.message}"
    end
    
    def parse_spec
      parse_info
      parse_servers
      parse_paths
      parse_schemas
    end
    
    def parse_info
      info = @spec['info'] || {}
      @api_info = {
        title: info['title'],
        version: info['version'],
        description: info['description']
      }
    end
    
    def parse_servers
      servers = @spec['servers'] || []
      @base_url = servers.first&.dig('url') || 'https://api.example.com'
    end
    
    def parse_paths
      paths = @spec['paths'] || {}
      
      paths.each do |path, methods|
        methods.each do |method, details|
          next if method.start_with?('$') # Skip special keys like $ref
          
          @endpoints << {
            path: path,
            method: method.upcase,
            operation_id: details['operationId'] || generate_operation_id(method, path),
            summary: details['summary'],
            description: details['description'],
            parameters: parse_parameters(details['parameters']),
            request_body: parse_request_body(details['requestBody']),
            responses: parse_responses(details['responses'])
          }
        end
      end
    end
    
    def parse_parameters(parameters)
      return [] unless parameters
      
      parameters.map do |param|
        {
          name: param['name'],
          location: param['in'],
          required: param['required'] || false,
          type: param['schema']&.dig('type') || 'string',
          description: param['description']
        }
      end
    end
    
    def parse_request_body(request_body)
      return nil unless request_body
      
      content = request_body['content'] || {}
      json_content = content['application/json'] || {}
      
      {
        required: request_body['required'] || false,
        schema: json_content['schema']
      }
    end
    
    def parse_responses(responses)
      return {} unless responses
      
      responses.transform_values do |response|
        {
          description: response['description'],
          content: response['content']
        }
      end
    end
    
    def parse_schemas
      components = @spec['components'] || {}
      schemas = components['schemas'] || {}
      
      schemas.each do |name, schema|
        @models[name] = {
          name: name,
          type: schema['type'],
          properties: parse_properties(schema['properties']),
          required: schema['required'] || []
        }
      end
    end
    
    def parse_properties(properties)
      return {} unless properties
      
      properties.transform_values do |prop|
        {
          type: prop['type'],
          format: prop['format'],
          description: prop['description'],
          items: prop['items']
        }
      end
    end
    
    def generate_operation_id(method, path)
      # Generate operation ID from method and path
      # e.g., GET /users/{id} -> getUserById
      path_parts = path.split('/').reject(&:empty?)
      path_name = path_parts.map do |part|
        part.start_with?('{') ? "by_#{part.tr('{}', '')}" : part
      end.join('_')
      
      "#{method}_#{path_name}".downcase
    end
  end
end