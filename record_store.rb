require 'csv'
require 'pathname'
require 'FileUtils'

class RecordStore

  <<-DOC
    Input Formats:
    LastName | FirstName | Gender | FavoriteColor | DateOfBirth
    LastName, FirstName, Gender, FavoriteColor, DateOfBirth
  DOC

  attr_accessor :records
  attr_reader   :headers, :inventory

  def initialize(fpath, headers_str)
    raise NoHeadersFound unless headers_str
    @headers = headers_str.split(/,|\|/) if headers_str
    if Pathname.new(fpath).exist?
      table = CSV.read(fpath)
      p table
      raise NoHeadersFound if table.first.empty? 
      raise HeadersMismatch if table.first != @headers
    else
      FileUtils.touch(fpath)
      table = CSV.open(fpath, 'wb', :headers => true) do |csv|
        csv << @headers if headers_str
      end
      p table
      raise NoHeadersFound if table.headers.empty?
    end
    @inventory = fpath
    @records = []

    table.each {|row| @records << row unless row.empty? or row == @headers}
    puts
  end

  def export
    CSV.open(@inventory, 'wb', :headers => true) do |csv|
      csv << @headers
      @records.each do |record|
        csv << record
      end
    end
  end

  def add(record_str)
    new_row = CSV::Row.new( @headers, record_str.split(/,|\|/) )
    raise InvalidRecord if new_row.fields.any? {|field| field == nil || field == ''}

    @records << new_row
  end

  def clear
    @records = []
    self.export
  end
end

class NoRecordsFound < StandardError; end 
class HeadersMismatch < StandardError; end 
class NoHeadersFound < StandardError; end 
class InvalidRecord < StandardError; end
