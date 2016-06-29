class RecordStore
  require 'csv'

  <<-DOC
    Input Formats:
    LastName | FirstName | Gender | FavoriteColor | DateOfBirth
    LastName, FirstName, Gender, FavoriteColor, DateOfBirth
  DOC

  attr_accessor :records
  attr_reader   :headers, :inventory

  def initialize(fpath)
    @inventory = fpath
    table = CSV.read(fpath, :headers => true)
    @records = []
    @headers = table.headers
    raise NoRecordsFound if @headers.empty?

    table.each {|row| @records << row}
  end

  def export
    CSV.open(@inventory, 'w', :headers => true) do |csv|
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
class InvalidRecord < StandardError; end
