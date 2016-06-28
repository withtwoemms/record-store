require_relative 'record_store'

describe 'RecordStore' do
  describe '#initialize' do
    let(:records) { 'records.csv' }
    let(:recordless) { 'recordless.csv' }
    let(:record_store) { RecordStore.new(records) }

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
end
