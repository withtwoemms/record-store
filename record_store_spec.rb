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

    it 'should increase the number of records by 1' do
      expect { record_store.add record_1 }.to change { record_store.records.count }.by(1)
      expect(record_store.records.last.fields.any? {|field| field == nil}).to be(false)
    end
    it 'should be able to handle "|" delimitting' do
      expect { record_store.add record_2 }.to change { record_store.records.count }.by(1)
      expect(record_store.records.last.fields.any? {|field| field == nil}).to be(false)
    end
  end
end
