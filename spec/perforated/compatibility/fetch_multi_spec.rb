require 'perforated'

describe Perforated::Compatibility do
  after { Perforated.cache = nil }

  describe '.fetch_multi' do
    it 'uses the fetch_multi method on the configured cache if present' do
      cache = Perforated.cache = double(:cache, fetch_multi: true)

      Perforated::Compatibility.fetch_multi(:one, :two)

      expect(cache).to have_received(:fetch_multi).with(:one, :two)
    end

    it 'falls back to the custom backfill if the cache does not support it' do
      cache = Perforated.cache

      Perforated::Compatibility.fetch_multi(:one, :two) do |key|
        key
      end
    end
  end
end
