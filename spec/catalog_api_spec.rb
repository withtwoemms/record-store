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
    let(:headers) { ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"] }
    let(:dummy_inventory) { 'spec/dummy-records.csv' }
    let(:record_store) { RecordStore.new(filepath: dummy_inventory, headers: headers) }
    let(:records) { record_store.records }
    let(:indexed_records) { Hash[(1..records.count).to_a.zip(records)] }

    it 'works for params[:term] = gender' do
      get '/records/gender'
      correct_order = [4, 3, 1, 2].map {|index| indexed_records[index].to_s}
      api_response = JSON.parse(last_response.body)
      expect(api_response).to eql(correct_order)
    end
    it 'works for params[:term] = birthdate' do
      get '/records/birthdate'
      correct_order = [4, 1, 3, 2].map {|index| indexed_records[index].to_s}
      api_response = JSON.parse(last_response.body)
      expect(api_response).to eql(correct_order)
    end
    it 'works for params[:term] = name' do
      get '/records/name'
      correct_order = [4, 3, 2, 1].map {|index| indexed_records[index].to_s}
      api_response = JSON.parse(last_response.body)
      expect(api_response).to eql(correct_order)
    end
  end
end
