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

  describe 'GET /records/:term' do
    let(:record_1) { 'McPersonson, Person, F, red, 4/20/1990' }
    let(:record_2) { 'McDoggerson | Dog | M | yellow | 4/20/2009' }
    let(:record_3) { 'McCatterson, Cat, F, blue, 4/20/2005' } 
    let(:record_4) { 'McBirdson, Bird, F, purple, 4/20/1943' } 
    let(:records) { [record_1, record_2, record_3, record_4] }
    let(:frecords) { records.map {|record| RecordStore.format record} }

    it 'works for params[:term] = gender' do
      get '/records/gender'
      correct_order = [frecords[0], frecords[3], frecords[2], frecords[1]]
      api_response = JSON.parse(last_response.body)
      correct_order.each_with_index do |frecord, i|
        expect(api_response[i]).to eql(frecord)
      end
    end
    it 'works for params[:term] = birthdate' do
      get '/records/birthdate'
      correct_order = [frecords[3], frecords[0], frecords[2], frecords[1]]
      api_response = JSON.parse(last_response.body)
      correct_order.each_with_index do |frecord, i|
        expect(api_response[i]).to eql(frecord)
      end
    end
    it 'works for params[:term] = name' do
      get '/records/name'
      correct_order = frecords.reverse
      api_response = JSON.parse(last_response.body)
      correct_order.each_with_index do |frecord, i|
        expect(api_response[i]).to eql(frecord)
      end
    end
  end
end
