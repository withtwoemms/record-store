require 'grape'

module Catalog
  class API < Grape::API
    version 'v1', using: :header, vendor: 'Funkytown'
    format :json

    resource :records do
      get 'example' do
        return {:example => "RECORDS OF THIS GENRE (#{params[:genre]}) WILL GO HERE"}
      end
    end
  end
end
