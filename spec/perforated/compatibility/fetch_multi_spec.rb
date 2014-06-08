require 'perforated'

describe Perforated::Compatibility do
  after { Perforated.cache = nil }

  describe '.fetch_multi' do
    it 'uses the fetch_multi method on the configured cache if present' do
      Perforated.cache = double(:store)

      expect(Perforated.cache).to receive(:fetch_multi).with(:one, :two)

      Perforated::Compatibility.fetch_multi(:one, :two) { |key| key }
    end

    it 'falls back to the custom backfill if the cache does not support it' do
      results = Perforated::Compatibility.fetch_multi(:one, :two) { |key| key.to_s }

      expect(results).to eq(one: 'one', two: 'two')
    end
  end
end
