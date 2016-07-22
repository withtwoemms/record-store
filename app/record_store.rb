require 'csv'

require_relative 'modules/record_store_operations'
require_relative 'modules/record_store_file_io'


class RecordStore
  include RecordStoreOperations
  include RecordStoreFileIO
  include DataStructures

  <<-NOTES
    Record Input Formats:
    LastName | FirstName | Gender | FavoriteColor | DateOfBirth
    LastName, FirstName, Gender, FavoriteColor, DateOfBirth
  NOTES

  attr_accessor :records
  attr_reader   :inventory, :genres
  
  def initialize(filepath:, headers: nil)
    @records = RecordAcquirer.fetch_or_create_records_from(filepath: filepath, headers: headers)
    @genres = RecordAcquirer.headers
    @inventory = filepath
  end

  def add(new_record_str:)
    new_record = Add.new(record_str: new_record_str, headers: @genres).record
    @records << new_record
  end
  
  def export(filepath:)
    filepath = filepath || @inventory
    export = Export.new(filepath: filepath, records: @records, headers: @genres)
    export.to_file
  end

  def sort(by:, order: nil)
    @records = Sort.new(records: @records, by: by, order: order).records
  end
end
