require 'csv'

class RecordStore
  def self.format(record_str)
    record_str.split(/,\s|\s\|\s/)
  end

  <<-DOC
    Record Formats:
    LastName | FirstName | Gender | FavoriteColor | DateOfBirth
    LastName, FirstName, Gender, FavoriteColor, DateOfBirth
  DOC

  attr_accessor :buffer
  attr_reader   :headers, :inventory, :records

  def initialize(fpath, headers_str, new_record_strs=[])
    expected_headers = RecordStore.format headers_str
    @records = []
    @buffer = []
    if File.exist? fpath
      CSV.foreach(fpath) do |row|
        @records << row.map(&:strip)
      end
      @headers = @records.shift
      raise HeadersMismatch if @headers != expected_headers
    else
      @headers = expected_headers
      CSV.open(fpath, 'w+') do |csv|
        csv << @headers
      end
    end
    @inventory = fpath

    refresh_buffer if new_record_strs.empty?
    new_record_strs.each {|record| self.add record} unless new_record_strs.empty?
  end

  def export
    # @buffer filled with records from file upon init
    # @buffer written to file 

    CSV.open(@inventory, 'w+') do |csv|
      csv << @headers
      @buffer.each {|record| csv << record}
    end
  end

  def add(record_str)
    raise InvalidRecord if record_str.nil? 
    new_record = RecordStore.format record_str
    raise InvalidRecord if new_record.length != @headers.length || new_record.nil?

    @buffer << new_record 
  end

  def clear_buffer
    @buffer = []
  end

  def refresh_buffer 
    @records.each {|record| @buffer << record} unless @records.empty?
  end

  def sort(*header_terms, **options)
    term = header_terms.shift
    position = @headers.index(term)

    # Special case for "Gender" bifurcation -- come up with clever generalization in the future :)
    if term == "Gender" && header_terms.count == 1
      next_term = header_terms.shift
      next_position = @headers.index(next_term)
      genders = @buffer.group_by {|record| record[position]}
      if options[:order] == 'ASC' || options[:order] == nil
        genders['F'].sort_by! {|record| record[next_position]} 
        genders['M'].sort_by! {|record| record[next_position]} 
      elsif options[:order] == 'DESC'
        genders['F'].sort_by! {|record| record[next_position]}.reverse!
        genders['M'].sort_by! {|record| record[next_position]}.reverse!
      end
      result = genders['F'] + genders['M']
      result.map! {|record| record.join(', ')}
      return RecordStore.new(@inventory, @headers.join(', '), result)
    end

    snippets = [] 
    raise EmptyBuffer if @buffer.empty?
    @buffer.each_with_index {|record, i| snippets << [i, record[position]]}

    if options[:order] == 'ASC' || options[:order] == nil
      snippets.sort_by! {|item| item.last}
    elsif options[:order] == 'DESC'
      snippets.sort_by! {|item| item.last}.reverse!
    end

    snippets.map! {|item| @buffer[item.first].join(', ')}
    self.clear_buffer
    snippets.each {|item| @buffer << item.split(', ')}
    return self.sort(*header_terms, **options) unless header_terms.empty?
    return RecordStore.new(@inventory, @headers.join(', '), snippets)
  end
end

class HeadersMismatch < StandardError; end 
class InvalidRecord < StandardError; end
class EmptyBuffer < StandardError; end
