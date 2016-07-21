require 'grape'
require_relative 'record_store'

module Catalog
  class API < Grape::API
    version 'v1', using: :header, vendor: 'Funkytown'
    format :json

    inventory = File.expand_path('./records.csv')
    headers = ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"]

    resource :records do
      get :example do
        return {:example => "RECORDS OF THIS GENRE (#{params[:example]}) WILL GO HERE"}
      end

      get :gender do
        record_store = RecordStore.new(filepath: inventory, headers: headers)
        record_store.sort(by: ['Gender', 'LastName'])
        return record_store.records
      end

      get :birthdate do
        record_store = RecordStore.new(filepath: inventory, headers: headers)
        record_store.sort(by: 'DateOfBirth')
        return record_store.records
      end

      get :name do
        record_store = RecordStore.new(filepath: inventory, headers: headers)
        record_store.sort(by: 'LastName')
        return record_store.records
      end
    end
  end
end
