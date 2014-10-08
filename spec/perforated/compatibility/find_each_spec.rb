require 'perforated/compatibility/find_each'

describe Perforated::Compatibility do
  describe '.find_each' do
    it 'iterates over an enumerable in batches' do
      enumerable = (2..100).to_a
      results    = []

      Perforated::Compatibility.find_each(enumerable, batch_size: 50) do |int|
        results << int * int
      end

      expect(results.length).to eq(enumerable.length)
      expect(results.first).to eq(4)
      expect(results.last).to eq(10000)
    end
  end
end
