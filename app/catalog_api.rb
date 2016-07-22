require 'grape'

require_relative 'record_store'


module Catalog
  class API < Grape::API
    version 'v1', using: :header, vendor: 'E. Obi'
    format :json

    before do
      header "Access-Control-Allow-Origin", "*"
    end

    inventory = File.expand_path('db/records.csv')
    headers = ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"]

    get :records do
      record_store = RecordStore.new(filepath: inventory, headers: headers)
      return record_store.records.map(&:content)
    end

    resource :records do
      get :example do
        return {:example => "RECORDS OF THIS GENRE (#{params[:example]}) WILL GO HERE"}
      end

      post :add do
        record_store = RecordStore.new(filepath: inventory, headers: headers)
        #puts params[:add].values.join(',')
        puts params
        record_store.add(new_record_str: params.to_hash.values.join(','))
        puts record_store.records
        return record_store.records.map(&:content)
      end

      get :gender do
        record_store = RecordStore.new(filepath: inventory, headers: headers)
        record_store.sort(by: ['Gender', 'LastName'])
        return record_store.records.map(&:content)
      end

      get :birthdate do
        record_store = RecordStore.new(filepath: inventory, headers: headers)
        record_store.sort(by: 'DateOfBirth')
        return record_store.records.map(&:content)
      end

      get :name do
        record_store = RecordStore.new(filepath: inventory, headers: headers)
        record_store.sort(by: 'LastName')
        return record_store.records.map(&:content)
      end
    end
  end
end
