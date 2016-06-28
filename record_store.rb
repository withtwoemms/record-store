class RecordStore
  require 'csv'

  <<-DOC
    Input Formats:
    LastName | FirstName | Gender | FavoriteColor | DateOfBirth
    LastName, FirstName, Gender, FavoriteColor, DateOfBirth
  DOC

  attr_accessor :records

  def initialize(fpath)
    @records = []
    CSV.foreach(fpath, :headers => true) do |csv|
      @records << csv
    end

    raise NoRecordsFound if @records.empty?
  end

  def add(record_str)
    raise 'NotImplemented'
  end
end

class NoRecordsFound < StandardError; end 
