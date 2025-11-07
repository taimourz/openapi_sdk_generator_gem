#!/usr/bin/env ruby
require_relative '../lib/openapi_sdk_generator'

puts "=" * 60
puts "OpenAPI SDK Generator - Example Usage"
puts "=" * 60
puts

puts "Example 1: Loading from local file"
puts "-" * 60
spec_file = File.join(__dir__, '..', 'test', 'fixtures', 'petstore.yaml')
parser = OpenapiSdkGenerator::Parser.new(spec_file)

puts " API Information:"
puts "  Title: #{parser.api_title}"
puts "  Version: #{parser.api_version}"
puts "  Base URL: #{parser.base_url}"
puts "  Endpoints: #{parser.endpoints.length}"
puts "  Models: #{parser.models.keys.join(', ')}"
puts

puts "Generating Ruby SDK..."
ruby_generator = OpenapiSdkGenerator::Generators::RubyGenerator.new(parser)
output_dir = File.join(__dir__, '..', 'output', 'ruby')
ruby_generator.write_to_directory(output_dir)
puts " Ruby SDK generated at: #{output_dir}"
puts

puts "Generating JavaScript SDK..."
js_generator = OpenapiSdkGenerator::Generators::JavascriptGenerator.new(parser)
output_dir_js = File.join(__dir__, '..', 'output', 'javascript')
js_generator.write_to_directory(output_dir_js)
puts " JavaScript SDK generated at: #{output_dir_js}"
puts

puts "Example 2: Loading from URL"
puts "-" * 60
url = "https://raw.githubusercontent.com/taimourz/openapi_sdk_generator_gem/refs/heads/main/test/fixtures/petstore.yaml"
puts "Fetching spec from: #{url}"
puts

begin
  parser_url = OpenapiSdkGenerator::Parser.new(url)
  puts " API Information:"
  puts "  Title: #{parser_url.api_title}"
  puts "  Version: #{parser_url.api_version}"
  puts "  Base URL: #{parser_url.base_url}"
  puts "  Endpoints: #{parser_url.endpoints.length}"
  puts "  Models: #{parser_url.models.keys.join(', ')}"
  puts
  
  puts "Generating Ruby SDK from URL..."
  ruby_gen_url = OpenapiSdkGenerator::Generators::RubyGenerator.new(parser_url)
  output_dir_url = File.join(__dir__, '..', 'output', 'ruby_from_url')
  ruby_gen_url.write_to_directory(output_dir_url)
  puts " Ruby SDK generated at: #{output_dir_url}"
rescue OpenapiSdkGenerator::Error => e
  puts " Error: #{e.message}"
end

puts
puts "=" * 60
puts "Examples completed! Check the output directories."
puts "=" * 60