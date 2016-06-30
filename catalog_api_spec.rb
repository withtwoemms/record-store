require_relative 'spec_helper'

describe Catalog::API do
  include Rack::Test::Methods

  def app
    Catalog::API
  end

  describe 'GET /records/:genre' do
    it 'should return a status code of 200' do
      get '/records/example'
      expect(last_response.status).to eq(200) 
    end 
  end 
end
