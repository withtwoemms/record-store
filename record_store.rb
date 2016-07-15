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
  def self.fetch_or_create_records_from(filepath:, headers: nil)
    records = []
    if File.exist? filepath
      CSV.foreach(filepath) do |row|
        records << row.map(&:strip)
      end
      headers = records.shift
    elsif headers
      warn("\n#{'*'*20}\nFile not found...\nCreated new file instead\n#{'*'*20}\n\n")
      CSV.open(filepath, 'w+') do |csv|
        csv << headers
      end
    else
      warn("\n#{'*'*20}\nFile not found...\nNo headers given\n#{'*'*20}\n\n")
    end
    return records.map {|row| Record.new(row: row, headers: headers)}
  end
end

module Operations
  class Adder
    def initialize(record_store:)
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
  
  def initialize(filepath:, headers: nil)
    @records = RecordAcquirer.fetch_or_create_records_from(filepath: filepath, headers: headers)
    @inventory = filepath
  end
end
