#!/usr/bin/env ruby
require_relative '../lib/openapi_sdk_generator'

puts "=" * 60
puts "OpenAPI SDK Generator - Example Usage"
puts "=" * 60
puts

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

puts "=" * 60
puts "Example completed! Check the output directories."
puts "=" * 60