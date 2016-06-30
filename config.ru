#\ -w -p 8765
use Rack::Reloader, 0
use Rack::ContentLength

require File.expand_path('catalog_api', File.dirname(__FILE__))

run Catalog::API
