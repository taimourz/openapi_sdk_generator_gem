/**
 * Swagger Petstore
 * A sample API that uses a petstore as an example to demonstrate features in the OpenAPI 3.0 specification
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
   * 
   * Returns all pets from the system that the user has access to
Nam sed condimentum est. Maecenas tempor sagittis sapien, nec rhoncus sem sagittis sit amet. Aenean at gravida augue, ac iaculis sem. Curabitur odio lorem, ornare eget elementum nec, cursus id lectus. Duis mi turpis, pulvinar ac eros ac, tincidunt varius justo. In hac habitasse platea dictumst. Integer at adipiscing ante, a sagittis ligula. Aenean pharetra tempor ante molestie imperdiet. Vivamus id aliquam diam. Cras quis velit non tortor eleifend sagittis. Praesent at enim pharetra urna volutpat venenatis eget eget mauris. In eleifend fermentum facilisis. Praesent enim enim, gravida ac sodales sed, placerat id erat. Suspendisse lacus dolor, consectetur non augue vel, vehicula interdum libero. Morbi euismod sagittis libero sed lacinia.

Sed tempus felis lobortis leo pulvinar rutrum. Nam mattis velit nisl, eu condimentum ligula luctus nec. Phasellus semper velit eget aliquet faucibus. In a mattis elit. Phasellus vel urna viverra, condimentum lorem id, rhoncus nibh. Ut pellentesque posuere elementum. Sed a varius odio. Morbi rhoncus ligula libero, vel eleifend nunc tristique vitae. Fusce et sem dui. Aenean nec scelerisque tortor. Fusce malesuada accumsan magna vel tempus. Quisque mollis felis eu dolor tristique, sit amet auctor felis gravida. Sed libero lorem, molestie sed nisl in, accumsan tempor nisi. Fusce sollicitudin massa ut lacinia mattis. Sed vel eleifend lorem. Pellentesque vitae felis pretium, pulvinar elit eu, euismod sapien.

   * @param {array} tags - tags to filter by
   * @param {number} limit - maximum number of results to return
   * @returns {Promise<object>}
   */
  async findpets(tags, limit) {
    let path = '/pets';
    
    const queryParams = new URLSearchParams();
    if (tags !== undefined && tags !== null) {
      queryParams.append('tags', tags);
    }
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
   * 
   * Creates a new pet in the store. Duplicates are allowed
   * @param {object} body - Request body
   * @returns {Promise<object>}
   */
  async addpet() {
    let path = '/pets';
    
    
    return this.makeRequest('POST', path, body);
  }
  
  /**
   * 
   * Returns a user based on a single ID, if the user does not have access to the pet
   * @param {number} id - ID of pet to fetch
   * @returns {Promise<object>}
   */
  async findPetById(id) {
    let path = '/pets/{id}';
    path = path.replace('{id}', id);
    
    
    return this.makeRequest('GET', path);
  }
  
  /**
   * 
   * deletes a single pet based on the ID supplied
   * @param {number} id - ID of pet to delete
   * @returns {Promise<object>}
   */
  async deletepet(id) {
    let path = '/pets/{id}';
    path = path.replace('{id}', id);
    
    
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

