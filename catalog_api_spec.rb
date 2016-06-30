require_relative 'spec_helper'

describe Catalog::API do
  include Rack::Test::Methods

  def app
    Catalog::API
  end

  describe 'GET /records/example' do
    it 'should return a status code of 200' do
      get '/records/example'
      expect(last_response.status).to eq(200) 
    end 
    it 'should return JSON' do
      get '/records/example'
      expect(JSON.parse(last_response.body).class).to eq(Hash)
    end
  end 
end
