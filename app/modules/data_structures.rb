module DataStructures
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
end

