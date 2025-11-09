# OpenAPI SDK Generator

[![Gem Version](https://badge.fury.io/rb/openapi_sdk_generator_gem.svg)](https://badge.fury.io/rb/openapi_sdk_generator_gem)

A Ruby gem that reads OpenAPI specifications and automatically generates type-safe client SDKs in multiple languages (Ruby and JavaScript).

## Installation

```bash
gem install openapi_sdk_generator_gem
```

## Usage

### Command Line Interface

Generate SDKs from an OpenAPI specification file or URL:

```bash
# Show help
openapi-sdk-generator --help

# Generate JavaScript SDK from local file
openapi-sdk-generator -i path/to/openapi.yaml -o ./output -l javascript

# Generate Ruby SDK from local file
openapi-sdk-generator -i path/to/openapi.yaml -o ./output -l ruby

# Generate from URL
openapi-sdk-generator -i https://example.com/openapi.yaml -o ./output -l ruby
```

**Options:**
- `-i, --input`: Path or URL to OpenAPI specification (YAML/JSON)
- `-o, --output`: Output directory for generated SDK
- `-l, --language`: Target language (`ruby` or `javascript`)

### Programmatic Usage

```ruby
require 'openapi_sdk_generator'

# Parse OpenAPI specification
parser = OpenapiSdkGenerator::Parser.new('path/to/openapi.yaml')

# Generate Ruby SDK
ruby_generator = OpenapiSdkGenerator::Generators::RubyGenerator.new(parser)
ruby_generator.write_to_directory('./output/ruby')

# Generate JavaScript SDK
js_generator = OpenapiSdkGenerator::Generators::JavascriptGenerator.new(parser)
js_generator.write_to_directory('./output/javascript')
```

### Using a URL

```ruby
require 'openapi_sdk_generator'

# Parse from URL
url = 'https://raw.githubusercontent.com/example/openapi.yaml'
parser = OpenapiSdkGenerator::Parser.new(url)

# Generate SDK
generator = OpenapiSdkGenerator::Generators::RubyGenerator.new(parser)
generator.write_to_directory('./output')
```

## Example

Using the Petstore OpenAPI specification:

```bash
openapi-sdk-generator \
  -i https://raw.githubusercontent.com/taimourz/openapi_sdk_generator_gem/main/test/fixtures/petstore.yaml \
  -o ./my-sdk \
  -l ruby
```

This generates:
```
my-sdk/
├── README.md          # Usage documentation
├── client.rb          # API client with all methods
└── models/            # Data models
    ├── pet.rb
    ├── error.rb
    └── newpet.rb
```

## Generated SDK Structure

### Ruby Output
- `client.rb` - Main API client with HTTP methods for each endpoint
- `models/*.rb` - Individual model classes with serialization/deserialization
- `README.md` - Auto-generated documentation with usage examples

### JavaScript Output
- `client.js` - API client with async/await methods
- `package.json` - NPM package configuration
- `README.md` - Auto-generated documentation

## Requirements

- Ruby 2.7 or higher
- OpenAPI Specification 3.0+

## Links

- **GitHub Repository**: [github.com/taimourz/openapi_sdk_generator_gem](https://github.com/taimourz/openapi_sdk_generator_gem)
- **RubyGems**: [rubygems.org/gems/openapi_sdk_generator_gem](https://rubygems.org/gems/openapi_sdk_generator_gem)
- **Blog Tutorial**: [taimourz.github.io/portfolio/notes/openapi-sdk](https://taimourz.github.io/portfolio/notes/openapi-sdk)
