require 'net/http'
require 'json'
require 'uri'

class APIClient
  attr_reader :base_url, :headers
  
  def initialize(base_url = 'http://petstore.swagger.io/api', api_key: nil)
    @base_url = base_url
    @headers = {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
    @headers['Authorization'] = "Bearer #{api_key}" if api_key
  end
  
  
  # 
  # Returns all pets from the system that the user has access to
Nam sed condimentum est. Maecenas tempor sagittis sapien, nec rhoncus sem sagittis sit amet. Aenean at gravida augue, ac iaculis sem. Curabitur odio lorem, ornare eget elementum nec, cursus id lectus. Duis mi turpis, pulvinar ac eros ac, tincidunt varius justo. In hac habitasse platea dictumst. Integer at adipiscing ante, a sagittis ligula. Aenean pharetra tempor ante molestie imperdiet. Vivamus id aliquam diam. Cras quis velit non tortor eleifend sagittis. Praesent at enim pharetra urna volutpat venenatis eget eget mauris. In eleifend fermentum facilisis. Praesent enim enim, gravida ac sodales sed, placerat id erat. Suspendisse lacus dolor, consectetur non augue vel, vehicula interdum libero. Morbi euismod sagittis libero sed lacinia.

Sed tempus felis lobortis leo pulvinar rutrum. Nam mattis velit nisl, eu condimentum ligula luctus nec. Phasellus semper velit eget aliquet faucibus. In a mattis elit. Phasellus vel urna viverra, condimentum lorem id, rhoncus nibh. Ut pellentesque posuere elementum. Sed a varius odio. Morbi rhoncus ligula libero, vel eleifend nunc tristique vitae. Fusce et sem dui. Aenean nec scelerisque tortor. Fusce malesuada accumsan magna vel tempus. Quisque mollis felis eu dolor tristique, sit amet auctor felis gravida. Sed libero lorem, molestie sed nisl in, accumsan tempor nisi. Fusce sollicitudin massa ut lacinia mattis. Sed vel eleifend lorem. Pellentesque vitae felis pretium, pulvinar elit eu, euismod sapien.

  def findpets(tags, limit)
    path = "/pets"
    
    query_params = {}
    query_params['tags'] = tags if tags
    query_params['limit'] = limit if limit
    path += "?#{URI.encode_www_form(query_params)}" unless query_params.empty?
    
    make_request('GET', path)
  end
  
  # 
  # Creates a new pet in the store.  Duplicates are allowed
  def addpet(body: nil)
    path = "/pets"
    
    
    make_request('POST', path, body: body)
  end
  
  # 
  # Returns a user based on a single ID, if the user does not have access to the pet
  def find_pet_by_id(id)
    path = "/pets/{id}"
    path = path.gsub('{id}', id.to_s)
    
    
    make_request('GET', path)
  end
  
  # 
  # deletes a single pet based on the ID supplied
  def deletepet(id)
    path = "/pets/{id}"
    path = path.gsub('{id}', id.to_s)
    
    
    make_request('DELETE', path)
  end
  
  
  private
  
  def make_request(method, path, body: nil)
    uri = URI.join(@base_url, path)
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    
    request = case method.upcase
    when 'GET'
      Net::HTTP::Get.new(uri)
    when 'POST'
      Net::HTTP::Post.new(uri)
    when 'PUT'
      Net::HTTP::Put.new(uri)
    when 'DELETE'
      Net::HTTP::Delete.new(uri)
    when 'PATCH'
      Net::HTTP::Patch.new(uri)
    else
      raise "Unsupported HTTP method: #{method}"
    end
    
    @headers.each { |key, value| request[key] = value }
    request.body = body.to_json if body
    
    response = http.request(request)
    
    case response
    when Net::HTTPSuccess
      response.body.empty? ? {} : JSON.parse(response.body)
    else
      raise "HTTP Error #{response.code}: #{response.body}"
    end
  end
end

