require "rack/test"
require 'stringio'

require_relative "../app/record_store"
require_relative "../app/modules/data_structures"
require_relative "../app/modules/record_store_file_io"
require_relative "../app/modules/record_store_operations"
require_relative "../app/catalog_api"


$stderr = StringIO.new  # redirect STDERR for specs
