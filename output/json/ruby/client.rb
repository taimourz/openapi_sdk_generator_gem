require 'net/http'
require 'json'
require 'uri'

class APIClient
  attr_reader :base_url, :headers
  
  def initialize(base_url = 'https://api.example.com', api_key: nil)
    @base_url = base_url
    @headers = {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
    @headers['Authorization'] = "Bearer #{api_key}" if api_key
  end
  
  
  # uploads an image
  # 
  def uploadfile(petid, additionalmetadata, file)
    path = "/pet/{petId}/uploadImage"
    path = path.gsub('{petId}', petid.to_s)
    
    
    make_request('POST', path)
  end
  
  # Add a new pet to the store
  # 
  def addpet(body)
    path = "/pet"
    
    
    make_request('POST', path)
  end
  
  # Update an existing pet
  # 
  def updatepet(body)
    path = "/pet"
    
    
    make_request('PUT', path)
  end
  
  # Finds Pets by status
  # Multiple status values can be provided with comma separated strings
  def findpetsbystatus(status)
    path = "/pet/findByStatus"
    
    query_params = {}
    query_params['status'] = status if status
    path += "?#{URI.encode_www_form(query_params)}" unless query_params.empty?
    
    make_request('GET', path)
  end
  
  # Finds Pets by tags
  # Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.
  def findpetsbytags(tags)
    path = "/pet/findByTags"
    
    query_params = {}
    query_params['tags'] = tags if tags
    path += "?#{URI.encode_www_form(query_params)}" unless query_params.empty?
    
    make_request('GET', path)
  end
  
  # Find pet by ID
  # Returns a single pet
  def getpetbyid(petid)
    path = "/pet/{petId}"
    path = path.gsub('{petId}', petid.to_s)
    
    
    make_request('GET', path)
  end
  
  # Updates a pet in the store with form data
  # 
  def updatepetwithform(petid, name, status)
    path = "/pet/{petId}"
    path = path.gsub('{petId}', petid.to_s)
    
    
    make_request('POST', path)
  end
  
  # Deletes a pet
  # 
  def deletepet(api_key, petid)
    path = "/pet/{petId}"
    path = path.gsub('{petId}', petid.to_s)
    
    
    make_request('DELETE', path)
  end
  
  # Returns pet inventories by status
  # Returns a map of status codes to quantities
  def getinventory()
    path = "/store/inventory"
    
    
    make_request('GET', path)
  end
  
  # Place an order for a pet
  # 
  def placeorder(body)
    path = "/store/order"
    
    
    make_request('POST', path)
  end
  
  # Find purchase order by ID
  # For valid response try integer IDs with value >= 1 and <= 10. Other values will generated exceptions
  def getorderbyid(orderid)
    path = "/store/order/{orderId}"
    path = path.gsub('{orderId}', orderid.to_s)
    
    
    make_request('GET', path)
  end
  
  # Delete purchase order by ID
  # For valid response try integer IDs with positive integer value. Negative or non-integer values will generate API errors
  def deleteorder(orderid)
    path = "/store/order/{orderId}"
    path = path.gsub('{orderId}', orderid.to_s)
    
    
    make_request('DELETE', path)
  end
  
  # Creates list of users with given input array
  # 
  def createuserswithlistinput(body)
    path = "/user/createWithList"
    
    
    make_request('POST', path)
  end
  
  # Get user by user name
  # 
  def getuserbyname(username)
    path = "/user/{username}"
    path = path.gsub('{username}', username.to_s)
    
    
    make_request('GET', path)
  end
  
  # Updated user
  # This can only be done by the logged in user.
  def updateuser(username, body)
    path = "/user/{username}"
    path = path.gsub('{username}', username.to_s)
    
    
    make_request('PUT', path)
  end
  
  # Delete user
  # This can only be done by the logged in user.
  def deleteuser(username)
    path = "/user/{username}"
    path = path.gsub('{username}', username.to_s)
    
    
    make_request('DELETE', path)
  end
  
  # Logs user into the system
  # 
  def loginuser(username, password)
    path = "/user/login"
    
    query_params = {}
    query_params['username'] = username if username
    query_params['password'] = password if password
    path += "?#{URI.encode_www_form(query_params)}" unless query_params.empty?
    
    make_request('GET', path)
  end
  
  # Logs out current logged in user session
  # 
  def logoutuser()
    path = "/user/logout"
    
    
    make_request('GET', path)
  end
  
  # Creates list of users with given input array
  # 
  def createuserswitharrayinput(body)
    path = "/user/createWithArray"
    
    
    make_request('POST', path)
  end
  
  # Create user
  # This can only be done by the logged in user.
  def createuser(body)
    path = "/user"
    
    
    make_request('POST', path)
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

