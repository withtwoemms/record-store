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
  
  describe '#add' do
    let(:record_1) { 'McPersonson, Person, F, red, 4/20/1990' }
    let(:record_2) { 'McPersonson | Person | M | red | 4/20/1990' }
    let(:records) { [record_1, record_2] }

    it 'should increase the number of records by 1' do
      expect { record_store.add(new_record_str: record_1) }.to change { record_store.records.count }.from(0).to(1)
    end
    it 'should be able to handle "|" delimitting' do
      expect { record_store.add(new_record_str: record_2) }.to change { record_store.records.count }.from(0).to(1)
    end
  end
  
  describe '#export' do
    let(:dummy_inventory) { 'spec/dummy-records.csv' }
    let(:inventory) { 'test-records.csv' }
    let(:headers) { ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"] }
    let(:record_store) { RecordStore.new(filepath: dummy_inventory, headers: headers) }
    
    after(:each) do
      File.delete('test-records.csv') if File.exist? 'test-records.csv'
    end

    it 'should save @records to file' do
      original_num_records = record_store.records.count
      record_store.add(new_record_str: 'McGatorson,Alligator,M,teal,4/20/1912')
      record_store.export(filepath: inventory)
      
      new_record_store = RecordStore.new(filepath: inventory, headers: headers)
      expect(new_record_store.records.count).to be > original_num_records
    end
  end

  describe '#sort' do
    let(:dummy_inventory) { 'spec/dummy-records.csv' }
    let(:inventory) { 'test-records.csv' }
    let(:headers) { ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"] }
    let(:record_store) { RecordStore.new(filepath: dummy_inventory, headers: headers) }

    after(:each) do
      File.delete('test-records.csv') if File.exist? 'test-records.csv'
    end

    it 'should sort an unsorted list of Records' do
      original_record_order = record_store.records
      record_store.sort(by: 'FavoriteColor')
      expect(original_record_order).not_to eql(record_store.records)
    end
  end
end

describe 'Operations' do
  let(:inventory) { 'test-records.csv' }
  let(:headers) { ["LastName", "FirstName", "Gender", "FavoriteColor", "DateOfBirth"] }

  describe '::Add' do
    describe '#initialize' do
      let(:record_1) { 'McPersonson, Person, F, red, 4/20/1990' }

      after(:each) do
        File.delete('test-records.csv') if File.exist? 'test-records.csv'
      end
  
      it 'should return an Add object with a record' do
        new_record = Operations::Add.new(record_str: record_1, headers: headers).record
        expect(new_record.class).to be(Record)
      end
    end
  end

  describe '::Export' do
    after(:each) do
      File.delete('test-records.csv') if File.exist? 'test-records.csv'
    end

    describe '#initialize' do
      let(:record_store) { RecordStore.new(filepath: inventory, headers: headers) }
      let(:records) { record_store.records }
      let(:export) { Operations::Export.new(filepath: inventory, records: records, headers: headers) }
      let(:necessary_attrs) { [:filepath, :records, :headers] }      

      it 'should return an Export object with attribute necessary for RecordStore#export' do
        necessary_attrs.each do |attr|
          expect(export).to respond_to(attr)
        end
      end
    end

    describe '#to_file' do
      let(:dummy_inventory) { 'spec/dummy-records.csv' }
      let(:record_store) { RecordStore.new(filepath: dummy_inventory, headers: headers) }
      let(:records) { record_store.records }
      let(:export) { Operations::Export.new(filepath: 'tmp.csv', records: records, headers: headers) }

      after(:each) { File.delete('tmp.csv') if File.exist? 'tmp.csv' }

      it 'should create a CSV at given filepath' do
        export.to_file
        expect(File.exist? 'tmp.csv').to be(true)
      end
      it 'should write Records to file' do
        export.to_file
        records_from_file = File.readlines(dummy_inventory).map(&:strip)[1..-1]
        expect(records_from_file).to match(record_store.records.map(&:to_s)) 
      end
    end
  end

  describe '::Sorter' do
    describe '#sort' do
      let(:dummy_inventory) { 'spec/dummy-records.csv' }
      let(:record_store) { RecordStore.new(filepath: dummy_inventory, headers: headers) }
      let(:records) { record_store.records }
      let(:indexed_records) { Hash[(1..records.count).to_a.zip(records)] }

      after(:each) do
        File.delete('test-records.csv') if File.exist? 'test-records.csv'
      end

      it 'should sort by some field and order ascending' do
        correct_order = [4, 3, 2, 1].map {|index| indexed_records[index]}
        record_store.sort(by: 'LastName', order: 'ASC')
        expect(correct_order).to eql(record_store.records)
      end
      it 'should sort by some field and order descending' do
        correct_order = [1, 2, 3, 4].map {|index| indexed_records[index]}
        record_store.sort(by: 'LastName', order: 'DESC')
        expect(correct_order).to eql(record_store.records)
      end
      it 'should sort by multiple fields' do
        correct_order = [4, 3, 1, 2].map {|index| indexed_records[index]}
        record_store.sort(by: ['Gender', 'LastName'], order: 'ASC')
        expect(correct_order).to eql(record_store.records)
      end
    end
  end

end
