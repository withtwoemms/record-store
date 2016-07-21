module RecordStoreOperations
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

