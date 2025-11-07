require 'json'
require 'yaml'
require 'erb'
require 'fileutils'

require_relative 'openapi_sdk_generator/parser'
require_relative 'openapi_sdk_generator/generator'
require_relative 'openapi_sdk_generator/generators/ruby_generator'
require_relative 'openapi_sdk_generator/generators/javascript_generator'

module OpenapiSdkGenerator
  class Error < StandardError; end
  
  class CLI
    def initialize(options)
      @options = options
    end
    
    def run
      validate_options!
      
      puts " Parsing OpenAPI specification..."
      parser = Parser.new(@options[:input])
      
      puts "Generating #{@options[:language]} SDK..."
      generator = create_generator(@options[:language], parser)
      
      puts " Writing files to #{@options[:output]}..."
      generator.write_to_directory(@options[:output])
      
      puts " SDK generated successfully!"
      puts "Output directory: #{@options[:output]}"
    rescue => e
      puts " Error: #{e.message}"
      exit 1
    end
    
    private
    
  def validate_options!
    raise Error, "Input is required" unless @options[:input]
    raise Error, "Output directory is required" unless @options[:output]
    raise Error, "Language is required (ruby or javascript)" unless @options[:language]

    unless url?(@options[:input]) || File.exist?(@options[:input])
      raise Error, "Input must be a valid file path or URL"
    end
  end


    def url?(value)
      value.start_with?("http://", "https://")
    end
    def create_generator(language, parser)
      case language.downcase
      when 'ruby'
        Generators::RubyGenerator.new(parser)
      when 'javascript', 'js'
        Generators::JavascriptGenerator.new(parser)
      else
        raise Error, "Unsupported language: #{language}"
      end
    end
  end
end