Gem::Specification.new do |s|
  s.name        = "openapi_sdk_generator_gem"
  s.version     = "0.1.0"
  s.summary     = "Generate SDKs from OpenAPI specifications"
  s.description = "A lightweight tool to generate client SDKs in multiple languages from OpenAPI/Swagger specs"
  s.authors     = ["Taimour Afzal"]
  s.email       = "taimour.ffcb@gmail.com"
  s.files       = Dir["lib/**/*.rb"] + Dir["lib/**/*.erb"]
  s.homepage    = "https://github.com/taimourz/openapi_sdk_generator_gem"
  s.license     = "MIT"
  s.executables << "openapi-sdk-generator"
  s.required_ruby_version = ">= 2.7.0"
  
  s.add_dependency "json", "~> 2.0"
  
  s.add_development_dependency "rspec", "~> 3.12"
  s.add_development_dependency "rake", "~> 13.0"
end