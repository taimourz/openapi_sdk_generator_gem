require_relative '../lib/openapi_sdk_generator'

RSpec.describe OpenapiSdkGenerator::Parser do
  let(:spec_file) { File.join(__dir__, '..', 'test', 'fixtures', 'petstore.yaml') }
  let(:parser) { OpenapiSdkGenerator::Parser.new(spec_file) }
  
  describe '#initialize' do
    it 'loads the OpenAPI specification' do
      expect(parser.spec).to be_a(Hash)
    end
    
    it 'extracts API info' do
      expect(parser.api_title).to eq('Petstore API')
      expect(parser.api_version).to eq('1.0.0')
      expect(parser.api_description).to include('pet store')
    end
    
    it 'extracts base URL' do
      expect(parser.base_url).to eq('https://petstore.swagger.io/v2')
    end
  end
  
  describe '#endpoints' do
    it 'parses all endpoints' do
      expect(parser.endpoints).to be_an(Array)
      expect(parser.endpoints.length).to be > 0
    end
    
    it 'includes GET /pets endpoint' do
      list_pets = parser.endpoints.find { |e| e[:operation_id] == 'listPets' }
      expect(list_pets).not_to be_nil
      expect(list_pets[:method]).to eq('GET')
      expect(list_pets[:path]).to eq('/pets')
    end
    
    it 'includes path parameters' do
      get_pet = parser.endpoints.find { |e| e[:operation_id] == 'getPetById' }
      expect(get_pet[:parameters]).to be_an(Array)
      
      pet_id_param = get_pet[:parameters].find { |p| p[:name] == 'petId' }
      expect(pet_id_param).not_to be_nil
      expect(pet_id_param[:location]).to eq('path')
      expect(pet_id_param[:required]).to be true
    end
  end
  
  describe '#models' do
    it 'parses schema definitions' do
      expect(parser.models).to be_a(Hash)
      expect(parser.models).to have_key('Pet')
    end
    
    it 'extracts model properties' do
      pet_model = parser.models['Pet']
      expect(pet_model[:properties]).to have_key('name')
      expect(pet_model[:properties]).to have_key('id')
    end
    
    it 'identifies required fields' do
      pet_model = parser.models['Pet']
      expect(pet_model[:required]).to include('name')
    end
  end
end