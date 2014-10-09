require 'perforated/compatibility/find_each'

describe Perforated::Compatibility::ArrayExtensions do
  FindEach = Struct.new(:array) do
    using Perforated::Compatibility::ArrayExtensions

    def perform(&block)
      array.find_each(batch_size: 50, &block)
    end
  end

  describe '#find_each' do
    it 'iterates over an enumerable in batches' do
      enumerable = (2..100).to_a
      eachable   = FindEach.new(enumerable)
      results    = []

      eachable.perform do |int|
        results << int * int
      end

      expect(results.length).to eq(enumerable.length)
      expect(results.first).to  eq(4)
      expect(results.last).to   eq(10000)
    end
  end
end
