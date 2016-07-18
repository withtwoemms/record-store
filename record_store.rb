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
    @@headers = headers
    if File.exist? filepath
      CSV.foreach(filepath) do |row|
        records << row.map(&:strip)
      end
      @@headers = records.shift
    elsif headers
      warn("\n#{'*'*20}\nFile not found...\nCreated new file instead\n#{'*'*20}\n\n")
      CSV.open(filepath, 'w+') do |csv|
        csv << headers
      end
    else
      warn("\n#{'*'*20}\nFile not found...\nNo headers given\n#{'*'*20}\n\n")
    end
    return records.map {|row| Record.new(row: row, headers: @@headers)}
  end

  def self.headers
    # returns headers of last file accessed
    @@headers
  end
end

module Operations
  class Add
    attr_reader :new_record

    def initialize(new_record_str:, headers:)
      formatted_record = new_record_str.split(/\s?+[,\|]\s?+/)
      @new_record = Record.new(row: formatted_record, headers: headers)
    end
  end

  class Export
    def initialize(record_store:)
    end
  end

  class Sort
    def initialize(record_store:)
    end
  end
end


#-- MAIN INTERFACE ----------------------------------------->>>

class RecordStore
  include Operations

  attr_reader   :inventory, :records, :genres
  
  def initialize(filepath:, headers: nil)
    @records = RecordAcquirer.fetch_or_create_records_from(filepath: filepath, headers: headers)
    @genres = RecordAcquirer.headers
    @inventory = filepath
  end

  def add(record_str)
    new_record = Add.new(new_record_str: record_str, headers: @genres).new_record
    @records << new_record
  end
end
