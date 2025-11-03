        # Swagger Petstore
        
        This is a sample server Petstore server.  You can find out more about Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net, #swagger](http://swagger.io/irc/).  For this sample, you can use the api key `special-key` to test the authorization filters.
        
        Version: 1.0.7
        
        ## Installation
```bash

npm install

## Usage
```javascript

const APIClient = require('./client');


// Example usage
    // uploads an image
    // const response = await client.uploadfile(...);


## Available Methods
        
        - `uploadfile()` - uploads an image
- `addpet()` - Add a new pet to the store
- `updatepet()` - Update an existing pet
- `findpetsbystatus()` - Finds Pets by status
- `findpetsbytags()` - Finds Pets by tags
- `getpetbyid()` - Find pet by ID
- `updatepetwithform()` - Updates a pet in the store with form data
- `deletepet()` - Deletes a pet
- `getinventory()` - Returns pet inventories by status
- `placeorder()` - Place an order for a pet
- `getorderbyid()` - Find purchase order by ID
- `deleteorder()` - Delete purchase order by ID
- `createuserswithlistinput()` - Creates list of users with given input array
- `getuserbyname()` - Get user by user name
- `updateuser()` - Updated user
- `deleteuser()` - Delete user
- `loginuser()` - Logs user into the system
- `logoutuser()` - Logs out current logged in user session
- `createuserswitharrayinput()` - Creates list of users with given input array
- `createuser()` - Create user
