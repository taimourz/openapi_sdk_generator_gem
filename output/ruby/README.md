# Petstore API

A sample API for managing a pet store

Version: 1.0.0

## Installation

Add this to your application's Gemfile:
```ruby
gem 'your_gem_name'
```

## Usage
```ruby
require_relative 'client'

client = APIClient.new('https://petstore.swagger.io/v2')

# Example usage
# List all pets
# response = client.listpets(...)
```

## Available Methods

- `listpets` - List all pets
- `createpet` - Create a pet
- `getpetbyid` - Get a pet by ID
- `updatepet` - Update a pet
- `deletepet` - Delete a pet
