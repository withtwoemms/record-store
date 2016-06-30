require 'csv'

class RecordStore
  def self.format(record_str)
    record_str.split(/,\s|\s\|\s/)
  end

  <<-DOC
    Record Formats:
    LastName | FirstName | Gender | FavoriteColor | DateOfBirth
    LastName, FirstName, Gender, FavoriteColor, DateOfBirth
  DOC

  attr_reader   :headers, :inventory, :records

  def initialize(fpath, headers_str, new_record_strs=[])
    expected_headers = RecordStore.format headers_str
    @records = []
    if File.exist? fpath
      CSV.foreach(fpath) do |row|
        @records << row.map(&:strip)
      end
      @headers = @records.shift
      raise HeadersMismatch if @headers != expected_headers
    else
      @headers = expected_headers
      CSV.open(fpath, 'w+') do |csv|
        csv << @headers
      end
    end
    @inventory = fpath

    new_record_strs.each {|record| self.add record}
  end

  def export
    CSV.open(@inventory, 'w+') do |csv|
      csv << @headers
      @records.each {|record| csv << record}
    end
  end

  def add(record_str)
    new_record = record_str.split(/,\s|\s\|\s/)
    raise InvalidRecord if new_record.length != @headers.length

    @records << new_record
  end

  def clear
    @records = []
  end

  def sort
    raise 'NotImplemented'
  end
end

class HeadersMismatch < StandardError; end 
class InvalidRecord < StandardError; end
