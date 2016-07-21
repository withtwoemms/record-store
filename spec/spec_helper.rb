require "rack/test"
require 'stringio'
require_relative "../record_store"
require_relative "../catalog_api"

$stderr = StringIO.new  # redirect STDERR for specs
