require_relative 'record_store'

describe 'RecordStore' do
  let(:inventory) { 'test-records.csv' }
  let(:genres) { 'LastName, FirstName, Gender, FavoriteColor, DateOfBirth' }
  let(:record) { 'McPersonson, Person, F, red, 4/20/1990' }

  describe '#initialize' do
    let(:fake_genres) { 'These, Are, The, Fake, Headers' }

    after(:each) do
      File.delete('test-records.csv') if File.exist? 'test-records.csv'
    end

    it 'should throw a HeadersMismatch error if existing "inventory" file has unexpected headers' do
      RecordStore.new(inventory, record)
      expect { RecordStore.new(inventory, fake_genres) }.to raise_error(HeadersMismatch)
    end
  end

  describe '#add' do
    let(:record_store) { RecordStore.new(inventory, genres) }
    let(:record_1) { 'McPersonson, Person, F, red, 4/20/1990' }
    let(:record_2) { 'McPersonson | Person | M | red | 4/20/1990' }
    let(:record_3) { 'McPersonson, Person, F, red' } 
    let(:records) { [record_1, record_2] }

    before(:each) do
      records.each {|record| record_store.add record}
    end

    after(:all) do
      File.delete('test-records.csv') if File.exist? 'test-records.csv'
    end

    it 'should increase the number of records by 1' do
      expect { record_store.add record_1 }.to change { record_store.buffer.count }.by(1)
    end
    it 'should be able to handle "|" delimitting' do
      expect { record_store.add record_2 }.to change { record_store.buffer.count }.by(1)
    end
    it 'should throw an error if too fiew fields' do
      expect { record_store.add record_3 }.to raise_error(InvalidRecord)
    end
    it 'should throw an error if too fiew fields' do
      expect { record_store.add nil }.to raise_error(InvalidRecord)
    end
  end

  describe '#export' do
    let(:record_store) { RecordStore.new(inventory, genres) }
    
    after(:each) do
      File.delete('test-records.csv') if File.exist? 'test-records.csv'
    end

    it 'should save @records to file' do
      original_num_records = record_store.records.count
      record_store.add record
      record_store.export
      
      new_record_store = RecordStore.new inventory, genres
      expect(new_record_store.records.count).to be > original_num_records
    end
  end

  describe '#clear_buffer' do
    let(:record_store) { RecordStore.new(inventory, genres) }

    after(:each) do
      File.delete('test-records.csv') if File.exist? 'test-records.csv'
    end

    it 'should remove all records' do
      record_store.add record
      
      expect { record_store.clear_buffer }.to change { record_store.buffer.count }.from(1).to(0)
    end
  end

  describe '#sort' do
    let(:record_store) { RecordStore.new(inventory, genres) }
    let(:record_1) { 'McPersonson, Person, F, red, 4/20/1990' }
    let(:record_2) { 'McDoggerson | Dog | M | yellow | 4/20/2009' }
    let(:record_3) { 'McCatterson, Cat, F, blue, 4/20/2005' } 
    let(:record_4) { 'McBirdson, Bird, F, purple, 4/20/1943' } 
    let(:records) { [record_1, record_2, record_3, record_4] }
    let(:frecords) { records.map {|record| RecordStore.format record} }

    before(:each) do
      records.each {|record| record_store.add record}
    end
    after(:each) do
      File.delete('test-records.csv') if File.exist? 'test-records.csv'
    end

    it 'should sort by some field and order ascending' do
      correct_order = [frecords[3], frecords[0], frecords[2], frecords[1]]

      sorted_records = record_store.sort('DateOfBirth', :order => 'ASC').buffer
      correct_order.each_with_index do |frecord, i|
        expect(sorted_records[i]).to eql(frecord)
      end
    end
    it 'should sort by some field and order descending' do
      correct_order = frecords

      sorted_records = record_store.sort('LastName', :order => 'DESC').buffer
      correct_order.each_with_index do |frecord, i|
        expect(sorted_records[i]).to eql(frecord)
      end
    end
    it 'should sort by multiple fields' do
      correct_order = [frecords[0], frecords[2], frecords[3], frecords[1]]

      sorted_records = record_store.sort('Gender', 'LastName', :order => 'DESC').buffer
      correct_order.each_with_index do |frecord, i|
        expect(sorted_records[i]).to eql(frecord)
      end
    end
  end

end
