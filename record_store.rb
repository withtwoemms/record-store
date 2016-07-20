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
  
  def to_row
    return content.values
  end

  def to_s
    return content.values.join(',')
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
    attr_reader :record

    def initialize(record_str:, headers:)
      formatted_record = record_str.split(/\s?+[,\|]\s?+/)
      @record = Record.new(row: formatted_record, headers: headers)
    end
  end

  class Export
    attr_reader :records, :headers, :filepath

    def initialize(filepath:, records:, headers:)
      @records = records       
      @headers = headers
      @filepath = filepath
    end

    def to_file
      CSV.open(@filepath, 'w+') do |csv|
        csv << @headers
        @records.map(&:to_row).each {|row| csv << row}
      end 
    end
  end

  class Sort
    attr_reader :records, :by, :order

    def initialize(records:, by:, order:)
      if by.class == Array
        if order == 'ASC' || order == nil
          @records = records.sort_by {|record| by.map {|term| record.content[term]}}
        elsif order == 'DESC'
          @records = records.sort_by {|record| by.map {|term| record.content[term]}}.reverse
        end
      else
        if order == 'ASC' || order == nil
          @records = records.sort_by {|record| record.content[by]}
        elsif order == 'DESC'
          @records = records.sort_by {|record| record.content[by]}.reverse
        end
        @by = by
        @order = order       
      end
    end
  end
end


#-- MAIN INTERFACE ----------------------------------------->>>

class RecordStore
  include Operations

  attr_reader   :inventory, :records, :genres
  
  def initialize(filepath:, headers:)
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

  def sort(records: @records, by:, order:)
    Sort.new(records: records, by: by, order: order) 
  end
end
