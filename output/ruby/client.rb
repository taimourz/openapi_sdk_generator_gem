require 'net/http'
require 'json'
require 'uri'

class APIClient
  attr_reader :base_url, :headers
  
  def initialize(base_url = 'https://petstore.swagger.io/v2', api_key: nil)
    @base_url = base_url
    @headers = {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
    @headers['Authorization'] = "Bearer #{api_key}" if api_key
  end
  
  
  # List all pets
  # Returns a list of all pets in the store
  def listpets()
    path = "/pets"
    
    query_params = {}
    query_params['limit'] = limit if limit
    path += "?#{URI.encode_www_form(query_params)}" unless query_params.empty?
    
    make_request('GET', path)
  end
  
  # Create a pet
  # Add a new pet to the store
  def createpet()
    path = "/pets"
    
    
    make_request('POST', path, body: body)
  end
  
  # Get a pet by ID
  # Returns a single pet
  def getpetbyid()
    path = "/pets/{petId}"
    path = path.gsub('{petId}', petid.to_s)
    
    
    make_request('GET', path)
  end
  
  # Update a pet
  # Update an existing pet
  def updatepet()
    path = "/pets/{petId}"
    path = path.gsub('{petId}', petid.to_s)
    
    
    make_request('PUT', path, body: body)
  end
  
  # Delete a pet
  # Remove a pet from the store
  def deletepet()
    path = "/pets/{petId}"
    path = path.gsub('{petId}', petid.to_s)
    
    
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

