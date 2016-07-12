require 'csv'

<<-DOC
  Record Formats:
  LastName | FirstName | Gender | FavoriteColor | DateOfBirth
  LastName, FirstName, Gender, FavoriteColor, DateOfBirth
DOC

class RecordStore
  include Operations

  def initialize(records:)
  end
end

class Record
  def initialize(row:)
  end
end

class RecordAcquirer
  def initialize(fpath:)
  end
end

module Operations
  class Sorter
    def initialize(record_store:)
    end
  end

  class Adder
    def initialize(record_store:)
    end
  end

  class Exporter
    def initialize(record_store:)
    end
  end
end
