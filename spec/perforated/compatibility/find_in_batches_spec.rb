require 'perforated/compatibility/find_in_batches'

describe Perforated::Compatibility::FindInBatches do
  FindBatches = Struct.new(:array) do
    using Perforated::Compatibility::FindInBatches

    def perform(&block)
      array.find_in_batches(batch_size: 50, &block)
    end
  end

  describe '#find_in_batches' do
    it 'iterates over an enumerable in batches' do
      enumerable = [1] * 100
      eachable   = FindBatches.new(enumerable)
      results    = []

      eachable.perform do |arr|
        results << arr.reduce(&:+)
      end

      expect(results).to eq([50, 50])
    end
  end
end
