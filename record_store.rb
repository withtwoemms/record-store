class RecordStore
  require 'csv'

  <<-DOC
    Input Formats:
    LastName | FirstName | Gender | FavoriteColor | DateOfBirth
    LastName, FirstName, Gender, FavoriteColor, DateOfBirth
  DOC

  def initialize(fpath)
    @records = []
    CSV.foreach(fpath, :headers => true) do |csv|
      @records << csv
    end

    raise NoRecordsFound if @records.empty?
  end
end

class NoRecordsFound < StandardError; end 
