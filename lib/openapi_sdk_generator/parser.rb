require 'uri'
require 'net/http'
require 'openssl'

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
      content = fetch_content
      parse_content(content)
    rescue => e
      raise Error, "Failed to load OpenAPI spec: #{e.message}"
    end
    
    def fetch_content
      if url?(@file_path)
        fetch_from_url(@file_path)
      else
        fetch_from_file(@file_path)
      end
    end
    
    def url?(path)
      path =~ /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
    end
    
    def fetch_from_url(url)

      uri = URI.parse(url)
      
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      
      unless response.is_a?(Net::HTTPSuccess)
        raise Error, "Failed to fetch URL: #{response.code} #{response.message}"
      end
      
      response.body
    rescue SocketError, Net::OpenTimeout, Net::ReadTimeout => e
      raise Error, "Network error while fetching URL: #{e.message}"
    end
    
    def fetch_from_file(file_path)
      unless File.exist?(file_path)
        raise Error, "File not found: #{file_path}"
      end
      File.read(file_path)
    end
    
    def parse_content(content)
      if looks_like_json?(content)
        JSON.parse(content)
      elsif looks_like_yaml?(content)
        YAML.load(content)
      else
        begin
          JSON.parse(content)
        rescue JSON::ParserError
          YAML.load(content)
        end
      end
    rescue JSON::ParserError, Psych::SyntaxError => e
      raise Error, "Failed to parse OpenAPI spec: #{e.message}"
    end
    
    def looks_like_json?(content)
      content.strip.start_with?('{', '[')
    end
    
    def looks_like_yaml?(content)
      content =~ /^\w+:/
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
        resolved_schema = resolve_schema(schema)

        @models[name] = {
          name: name,
          type: resolved_schema['type'],
          properties: parse_properties(resolved_schema['properties']),
          required: resolved_schema['required'] || []
        }
      end
    end


    def resolve_schema(schema)
      if schema['$ref']
        return resolve_schema(ref_to_schema(schema['$ref']))
      end

      if schema['allOf']
        merged = { 'properties' => {}, 'required' => [] }

        schema['allOf'].each do |subschema|
          resolved = resolve_schema(subschema)
          merged['properties'].merge!(resolved['properties'] || {})
          merged['required'] |= (resolved['required'] || [])
        end

        return merged
      end

      schema
    end  


    def ref_to_schema(ref)
      ref_path = ref.sub('#/components/schemas/', '')
      @spec['components']['schemas'][ref_path]
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