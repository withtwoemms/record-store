require_relative 'record_store'

describe 'RecordStore' do
  let(:inventory) { 'records.csv' }
  let(:genres) { 'LastName, FirstName, Gender, FavoriteColor, DateOfBirth' }
  let(:record) { 'McPersonson, Person, F, red, 4/20/1990' }

  describe '#initialize' do
    after(:each) do
      File.delete('records.csv') if File.exist? 'records.csv'
    end

    it 'should throw a HeadersMismatch error if existing "inventory" file has unexpected headers' do
      expect { RecordStore.new(inventory, record) }.to raise_error(HeadersMismatch)
    end
    it 'should throw a NoHeadersFound error if existing "inventory" has nil headers' do 
      expect { RecordStore.new(inventory, nil) }.to raise_error(NoHeadersFound)
    end
    it 'should throw a NoHeadersFound error if existing "inventory" has empty headers' do 
      expect { RecordStore.new(inventory, '') }.to raise_error(NoHeadersFound)
    end
  end

  describe '#add' do
    let(:record_store) { RecordStore.new(inventory, genres) }
    let(:record_1) { 'McPersonson, Person, F, red, 4/20/1990' }
    let(:record_2) { 'McPersonson | Person | F | red | 4/20/1990' }
    let(:record_3) { 'McPersonson, Person, F, red' } # invalid -- nil field
    let(:record_4) { 'McPersonson, Person, F, red,' } # invalid -- '' field

    after(:all) do
      File.delete('records.csv') if File.exist? 'records.csv'
    end

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
    let(:record_store) { RecordStore.new(inventory, genres) }
    
    it 'should save @records to file' do
      original_num_records = record_store.records.count
      record_store.add record
      record_store.export
      
      new_record_store = RecordStore.new inventory, genres
      expect(new_record_store.records.count).to be > original_num_records
    end
  end

  describe '#clear' do
    let(:record_store) { RecordStore.new(inventory, genres) }

    it 'should remove all records' do
      record_store.add record
      p record_store
      
      expect { record_store.clear }.to change { record_store.records.count }.from(1).to(0)
      File.delete(inventory)
    end
  end

end
