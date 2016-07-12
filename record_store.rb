require 'csv'

class RecordStore
  <<-DOC
    Record Formats:
    LastName | FirstName | Gender | FavoriteColor | DateOfBirth
    LastName, FirstName, Gender, FavoriteColor, DateOfBirth
  DOC

  def initialize(fpath, headers_str, new_record_strs=[])
  end

  def export
  end

  def add(record_str)
  end

  def sort(*header_terms, **options)
  end
end
