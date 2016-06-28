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
    let(:record) { 'McPersonson, Person, F, red, 4/20/1990' }

    it 'should increase the number of records by 1' do
      expect { record_store.add record }.to change { record_store.records.count }.by(1)
    end
  end
end
