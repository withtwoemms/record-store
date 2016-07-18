require_relative 'spec_helper'

describe 'Record' do
  let(:inventory) { 'test-records.csv' }
  let(:headers) { ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"] }
  let(:row) { ["McPersonson", "Person", "F", "red", "4/20/1990"] }
  let(:record) { Record.new(row: row, headers: headers) }

  describe '#initialize' do
    after(:each) do
      File.delete('test-records.csv') if File.exist? 'test-records.csv'
    end

    it 'should have content' do
      expect(record.content.class).to be(Hash) 
    end
  end
end

describe 'RecordAcquirer' do
  let(:dummy_inventory) { 'spec/dummy-records.csv' }
  let(:fake_inventory) { 'fake-records.csv' }
  let(:headers) { ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"] }

  describe '#fetch_or_create_records_from' do
    after(:each) do
      File.delete('fake-records.csv') if File.exist? 'fake-records.csv'
    end

    it 'should return an array of Record objects if reading from file' do
      records = RecordAcquirer.fetch_or_create_records_from(filepath: dummy_inventory, headers: headers)
      expect(records.all? {|record| record.class == Record}).to be(true)
    end 
    it 'should create a file if file not present and headers given' do
      RecordAcquirer.fetch_or_create_records_from(filepath: fake_inventory, headers: headers)
      expect(File.exist? fake_inventory).to be(true)
    end 
    it 'should NOT create a file if file not present and headers NOT given' do
      RecordAcquirer.fetch_or_create_records_from(filepath: fake_inventory)
      expect(File.exist? fake_inventory).to be(false)
    end 
  end
end

describe 'RecordStore' do
  let(:inventory) { 'test-records.csv' }
  let(:headers) { ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"] }
  let(:record_store) { RecordStore.new(filepath: inventory, headers: headers) }

  describe '#initialize' do
    after(:each) do
      File.delete('test-records.csv') if File.exist? 'test-records.csv'
    end

    it 'should have @records associated if records fetched from file' do
      expect(record_store.records.all? {|record| record.class == Record}).to be(true)
    end
    it 'should have a @inventory if instantiated' do
      expect(record_store.inventory.class).to be(String)
    end
  end
end

describe 'Operations' do
  let(:inventory) { 'test-records.csv' }
  let(:headers) { ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"] }

  describe '::Add' do
    describe '#initialize' do
      let(:record_1) { 'McPersonson, Person, F, red, 4/20/1990' }

      after(:all) do
        File.delete('test-records.csv') if File.exist? 'test-records.csv'
      end
  
      it 'should return an Add object with a new_record' do
        new_record = Operations::Add.new(new_record_str: record_1, headers: headers).new_record
        expect(new_record.class).to be(Record)
      end

=begin
      let(:record_1) { 'McPersonson, Person, F, red, 4/20/1990' }
      let(:record_2) { 'McPersonson | Person | M | red | 4/20/1990' }
      let(:records) { [record_1, record_2] }

      before(:each) do
        records.each {|record| record_store.add record}
      end

      it 'should increase the number of records by 1' do
        expect { record_store.add record_1 }.to change { record_store.buffer.count }.by(1)
      end
      it 'should be able to handle "|" delimitting' do
        expect { record_store.add record_2 }.to change { record_store.buffer.count }.by(1)
      end
=end
    end
  end

  describe '::Export' do
    let(:dummy_inventory) { 'spec/dummy-records.csv' }
    let(:headers) { ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"] }

    describe '#initialize' do
      let(:inventory) { 'test-records.csv' }
      let(:record_store) { RecordStore.new(filepath: dummy_inventory, headers: headers) }
      
      after(:each) do
        File.delete('test-records.csv') if File.exist? 'test-records.csv'
        #File.delete('dummy-records.csv') if File.exist? 'dummy-records.csv'
      end

      it 'should save @records to file' do
        original_num_records = record_store.records.count
        record_store.add 'McGatorson,Alligator,M,teal,4/20/1912'
        record_store.export(filepath: inventory)
        
        new_record_store = RecordStore.new(filepath: inventory, headers: headers)
        expect(new_record_store.records.count).to be > original_num_records
      end
    end
    #describe '#to_file' do
    #end
  end
=begin
  describe '::Sorter' do
    describe '#sort' do
      #let(:record_store) { RecordStore.new(inventory, genres) }
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

end

describe '#clear_buffer' do
  #let(:record_store) { RecordStore.new(inventory, genres) }

  after(:each) do
    File.delete('test-records.csv') if File.exist? 'test-records.csv'
  end

  it 'should remove all records' do
    record_store.add record
    
    expect { record_store.clear_buffer }.to change { record_store.buffer.count }.from(1).to(0)
  end
end

describe '#refresh_buffer' do
  #let(:dummy_inventory) { 'spec/dummy-records.csv' }

  it 'should fill @buffer from @records if @records present and there are no new records passed' do
    record_store = RecordStore.new(dummy_inventory, genres)
    expect(record_store.buffer).not_to be_empty
  end
=end
end
