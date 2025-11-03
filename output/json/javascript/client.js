/**
 * Swagger Petstore
 * This is a sample server Petstore server.  You can find out more about Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net, #swagger](http://swagger.io/irc/).  For this sample, you can use the api key `special-key` to test the authorization filters.
 * Version: 1.0.7
 */

class APIClient {
  constructor(baseUrl = 'https://api.example.com', apiKey = null) {
    this.baseUrl = baseUrl;
    this.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    
    if (apiKey) {
      this.headers['Authorization'] = `Bearer ${apiKey}`;
    }
  }
  
  
  /**
   * uploads an image
   * 
   * @param {string} petid - ID of pet to update
   * @param {string} additionalmetadata - Additional data to pass to server
   * @param {string} file - file to upload
   * @returns {Promise<object>}
   */
  async uploadfile(petid, additionalmetadata, file) {
    let path = '/pet/{petId}/uploadImage';
    path = path.replace('{petId}', petid);
    
    
    return this.makeRequest('POST', path);
  }
  
  /**
   * Add a new pet to the store
   * 
   * @param {string} body - Pet object that needs to be added to the store
   * @returns {Promise<object>}
   */
  async addpet(body) {
    let path = '/pet';
    
    
    return this.makeRequest('POST', path);
  }
  
  /**
   * Update an existing pet
   * 
   * @param {string} body - Pet object that needs to be added to the store
   * @returns {Promise<object>}
   */
  async updatepet(body) {
    let path = '/pet';
    
    
    return this.makeRequest('PUT', path);
  }
  
  /**
   * Finds Pets by status
   * Multiple status values can be provided with comma separated strings
   * @param {string} status - Status values that need to be considered for filter
   * @returns {Promise<object>}
   */
  async findpetsbystatus(status) {
    let path = '/pet/findByStatus';
    
    const queryParams = new URLSearchParams();
    if (status !== undefined && status !== null) {
      queryParams.append('status', status);
    }
    
    const queryString = queryParams.toString();
    if (queryString) {
      path += `?${queryString}`;
    }
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * Finds Pets by tags
   * Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.
   * @param {string} tags - Tags to filter by
   * @returns {Promise<object>}
   */
  async findpetsbytags(tags) {
    let path = '/pet/findByTags';
    
    const queryParams = new URLSearchParams();
    if (tags !== undefined && tags !== null) {
      queryParams.append('tags', tags);
    }
    
    const queryString = queryParams.toString();
    if (queryString) {
      path += `?${queryString}`;
    }
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * Find pet by ID
   * Returns a single pet
   * @param {string} petid - ID of pet to return
   * @returns {Promise<object>}
   */
  async getpetbyid(petid) {
    let path = '/pet/{petId}';
    path = path.replace('{petId}', petid);
    
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * Updates a pet in the store with form data
   * 
   * @param {string} petid - ID of pet that needs to be updated
   * @param {string} name - Updated name of the pet
   * @param {string} status - Updated status of the pet
   * @returns {Promise<object>}
   */
  async updatepetwithform(petid, name, status) {
    let path = '/pet/{petId}';
    path = path.replace('{petId}', petid);
    
    
    return this.makeRequest('POST', path);
  }
  
  /**
   * Deletes a pet
   * 
   * @param {string} api_key - 
   * @param {string} petid - Pet id to delete
   * @returns {Promise<object>}
   */
  async deletepet(api_key, petid) {
    let path = '/pet/{petId}';
    path = path.replace('{petId}', petid);
    
    
    return this.makeRequest('DELETE', path);
  }
  
  /**
   * Returns pet inventories by status
   * Returns a map of status codes to quantities
   * @returns {Promise<object>}
   */
  async getinventory() {
    let path = '/store/inventory';
    
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * Place an order for a pet
   * 
   * @param {string} body - order placed for purchasing the pet
   * @returns {Promise<object>}
   */
  async placeorder(body) {
    let path = '/store/order';
    
    
    return this.makeRequest('POST', path);
  }
  
  /**
   * Find purchase order by ID
   * For valid response try integer IDs with value >= 1 and <= 10. Other values will generated exceptions
   * @param {string} orderid - ID of pet that needs to be fetched
   * @returns {Promise<object>}
   */
  async getorderbyid(orderid) {
    let path = '/store/order/{orderId}';
    path = path.replace('{orderId}', orderid);
    
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * Delete purchase order by ID
   * For valid response try integer IDs with positive integer value. Negative or non-integer values will generate API errors
   * @param {string} orderid - ID of the order that needs to be deleted
   * @returns {Promise<object>}
   */
  async deleteorder(orderid) {
    let path = '/store/order/{orderId}';
    path = path.replace('{orderId}', orderid);
    
    
    return this.makeRequest('DELETE', path);
  }
  
  /**
   * Creates list of users with given input array
   * 
   * @param {array} body - List of user object
   * @returns {Promise<object>}
   */
  async createuserswithlistinput(body) {
    let path = '/user/createWithList';
    
    
    return this.makeRequest('POST', path);
  }
  
  /**
   * Get user by user name
   * 
   * @param {string} username - The name that needs to be fetched. Use user1 for testing. 
   * @returns {Promise<object>}
   */
  async getuserbyname(username) {
    let path = '/user/{username}';
    path = path.replace('{username}', username);
    
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * Updated user
   * This can only be done by the logged in user.
   * @param {string} username - name that need to be updated
   * @param {string} body - Updated user object
   * @returns {Promise<object>}
   */
  async updateuser(username, body) {
    let path = '/user/{username}';
    path = path.replace('{username}', username);
    
    
    return this.makeRequest('PUT', path);
  }
  
  /**
   * Delete user
   * This can only be done by the logged in user.
   * @param {string} username - The name that needs to be deleted
   * @returns {Promise<object>}
   */
  async deleteuser(username) {
    let path = '/user/{username}';
    path = path.replace('{username}', username);
    
    
    return this.makeRequest('DELETE', path);
  }
  
  /**
   * Logs user into the system
   * 
   * @param {string} username - The user name for login
   * @param {string} password - The password for login in clear text
   * @returns {Promise<object>}
   */
  async loginuser(username, password) {
    let path = '/user/login';
    
    const queryParams = new URLSearchParams();
    if (username !== undefined && username !== null) {
      queryParams.append('username', username);
    }
    if (password !== undefined && password !== null) {
      queryParams.append('password', password);
    }
    
    const queryString = queryParams.toString();
    if (queryString) {
      path += `?${queryString}`;
    }
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * Logs out current logged in user session
   * 
   * @returns {Promise<object>}
   */
  async logoutuser() {
    let path = '/user/logout';
    
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * Creates list of users with given input array
   * 
   * @param {array} body - List of user object
   * @returns {Promise<object>}
   */
  async createuserswitharrayinput(body) {
    let path = '/user/createWithArray';
    
    
    return this.makeRequest('POST', path);
  }
  
  /**
   * Create user
   * This can only be done by the logged in user.
   * @param {string} body - Created user object
   * @returns {Promise<object>}
   */
  async createuser(body) {
    let path = '/user';
    
    
    return this.makeRequest('POST', path);
  }
  
  
  async makeRequest(method, path, body = null) {
    const url = `${this.baseUrl}${path}`;
    
    const options = {
      method: method,
      headers: this.headers
    };
    
    if (body) {
      options.body = JSON.stringify(body);
    }
    
    try {
      const response = await fetch(url, options);
      
      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`HTTP Error ${response.status}: ${errorText}`);
      }
      
      const contentType = response.headers.get('content-type');
      if (contentType && contentType.includes('application/json')) {
        return await response.json();
      }
      
      return await response.text();
    } catch (error) {
      throw new Error(`Request failed: ${error.message}`);
    }
  }
}

module.exports = APIClient;

