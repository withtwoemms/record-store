require 'grape'
require_relative 'record_store'

module Catalog
  class API < Grape::API
    version 'v1', using: :header, vendor: 'Funkytown'
    format :json

    inventory = File.expand_path('./records.csv')
    genres = 'LastName, FirstName, Gender, FavoriteColor, DateOfBirth'

    resource :records do
      get :example do
        return {:example => "RECORDS OF THIS GENRE (#{params[:example]}) WILL GO HERE"}
      end

      get :gender do
        return RecordStore.new(inventory, genres).sort('Gender').buffer
      end

      get :birthdate do
        return RecordStore.new(inventory, genres).sort('DateOfBirth').buffer
      end

      get :name do
        return RecordStore.new(inventory, genres).sort('LastName').buffer
      end
    end
  end
end
