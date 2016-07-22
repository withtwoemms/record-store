require_relative 'data_structures'


module RecordStoreFileIO
  class RecordAcquirer
    include DataStructures

    def self.fetch_or_create_records_from(filepath:, headers: nil)
      records = []
      @@headers = headers
      if File.exist? filepath
        CSV.foreach(filepath) do |row|
          records << row.map(&:strip)
        end
        @@headers = records.shift
      elsif headers
        warn("\n>> WARNING #{'*'*9}\nFile not found...\nCreated new file instead\n#{'*'*20}\n\n")
        CSV.open(filepath, 'w+') do |csv|
          csv << headers
        end
      else
        warn("\n>> WARNING #{'*'*9}\nFile not found...\nNo headers given\n#{'*'*20}\n\n")
      end
      return records.map {|row| Record.new(row: row, headers: @@headers)}
    end

    def self.headers
      # returns headers of last file accessed
      @@headers
    end
  end
end

