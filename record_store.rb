class RecordStore
  require 'csv'

  <<-DOC
    Input Formats:
    LastName | FirstName | Gender | FavoriteColor | DateOfBirth
    LastName, FirstName, Gender, FavoriteColor, DateOfBirth
  DOC

  attr_accessor :records
  attr_reader   :headers

  def initialize(fpath)
    table = CSV.read(fpath, :headers => true)
    @records = []
    @headers = table.headers
    raise NoRecordsFound if @headers.empty?

    table.each {|row| @records << row}
  end

  def add(record_str)
    @records << CSV::Row.new( @headers, record_str.split(/,|\|/) )
  end
end

class NoRecordsFound < StandardError; end 
class InvalidRecord < StandardError; end
