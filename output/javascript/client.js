/**
 * Petstore API
 * A sample API for managing a pet store
 * Version: 1.0.0
 */

class APIClient {
  constructor(baseUrl = 'https://petstore.swagger.io/v2', apiKey = null) {
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
   * List all pets
   * Returns a list of all pets in the store
   * @param {number} limit - Maximum number of pets to return
   * @returns {Promise<object>}
   */
  async listpets(limit) {
    let path = '/pets';
    
    const queryParams = new URLSearchParams();
    if (limit !== undefined && limit !== null) {
      queryParams.append('limit', limit);
    }
    
    const queryString = queryParams.toString();
    if (queryString) {
      path += `?${queryString}`;
    }
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * Create a pet
   * Add a new pet to the store
   * @param {object} body - Request body
   * @returns {Promise<object>}
   */
  async createpet() {
    let path = '/pets';
    
    
    return this.makeRequest('POST', path, body);
  }
  
  /**
   * Get a pet by ID
   * Returns a single pet
   * @param {number} petid - ID of pet to return
   * @returns {Promise<object>}
   */
  async getpetbyid(petid) {
    let path = '/pets/{petId}';
    path = path.replace('{petId}', petid);
    
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * Update a pet
   * Update an existing pet
   * @param {number} petid - 
   * @param {object} body - Request body
   * @returns {Promise<object>}
   */
  async updatepet(petid) {
    let path = '/pets/{petId}';
    path = path.replace('{petId}', petid);
    
    
    return this.makeRequest('PUT', path, body);
  }
  
  /**
   * Delete a pet
   * Remove a pet from the store
   * @param {number} petid - 
   * @returns {Promise<object>}
   */
  async deletepet(petid) {
    let path = '/pets/{petId}';
    path = path.replace('{petId}', petid);
    
    
    return this.makeRequest('DELETE', path);
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

