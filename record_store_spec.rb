require_relative 'record_store'

describe 'RecordStore' do
  describe '#initialize' do
    let(:record_store) { RecordStore.new('records.csv') }

    it 'should create a RecordStore object' do
      expect(record_store.class).to be(RecordStore)
    end
  end
end
