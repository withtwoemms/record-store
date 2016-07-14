require 'csv'

<<-DOC
  Record Formats:
  LastName | FirstName | Gender | FavoriteColor | DateOfBirth
  LastName, FirstName, Gender, FavoriteColor, DateOfBirth
DOC

class Record
  attr_reader   :content

  def initialize(row:, headers:)
    @content = Hash[headers.zip(row)]
  end
end

class RecordAcquirer
  def self.fetch_records_from(file:)
    records = []
    if File.exist? file
      CSV.foreach(file) do |row|
        records << row.map(&:strip)
      end
    else
      raise 'FileNotFound'
    end
    headers = records.shift
    return records.map {|row| Record.new(row: row, headers: headers)}
  end
end

module Operations
  class Adder
    def initialize(record_store:, record:)
    end
  end

  class Exporter
    def initialize(record_store:)
    end
  end

  class Sorter
    def initialize(record_store:)
    end
  end
end


#-- MAIN INTERFACE ----------------------------------------->>>

class RecordStore
  include Operations

  attr_reader   :inventory, :records
  
  def initialize(filepath:)
    @records = RecordAcquirer.fetch_records_from(file: filepath)
    @inventory = filepath
  end
end
