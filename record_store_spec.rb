require_relative 'record_store'

describe 'RecordStore' do
  let(:records) { 'records.csv' }
  let(:recordless) { 'recordless.csv' }
  let(:record_store) { RecordStore.new(records) }

  describe '#initialize' do
    it 'should create a RecordStore object' do
      expect(record_store.class).to be(RecordStore)
    end
    it 'should throw a NoRecordsFound error if none present' do
      expect { RecordStore.new(recordless) }.to raise_error(NoRecordsFound)
    end
    it 'should have records if some found' do
      expect(record_store.records).not_to be_empty
    end
  end

  describe '#add' do
    let(:record_1) { 'McPersonson, Person, F, red, 4/20/1990' }
    let(:record_2) { 'McPersonson | Person | F | red | 4/20/1990' }
    let(:record_3) { 'McPersonson, Person, F, red' } # invalid -- nil field
    let(:record_4) { 'McPersonson, Person, F, red,' } # invalid -- '' field

    it 'should increase the number of records by 1' do
      expect { record_store.add record_1 }.to change { record_store.records.count }.by(1)
    end
    it 'should be able to handle "|" delimitting' do
      expect { record_store.add record_2 }.to change { record_store.records.count }.by(1)
    end
    it 'should throw an error if any field is invalid' do
      # "invalid" fields are nil or ''
      expect { record_store.add record_3 }.to raise_error(InvalidRecord)
      expect { record_store.add record_4 }.to raise_error(InvalidRecord)
    end
  end

  describe '#export' do
    let(:record) { 'McPersonson, Person, F, red, 4/20/1990' }
    
    it 'should save @records to file' do
      original_num_records = record_store.records.count
      record_store.add record
      record_store.export
      
      new_record_store = RecordStore.new records
      expect(new_record_store.records.count).to be > original_num_records
    end
  end

  describe '#clear' do
    it 'should remove all records' do
      record_store.clear
      expect { RecordStore.new records }.to raise_error(NoRecordsFound)
    end
  end
end
