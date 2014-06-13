require 'perforated'

describe Perforated do
  after { Perforated.reset! }

  describe '#configuration' do
    it 'stores an injected cache object' do
      custom_cache = Object.new
      custom_parse = Object.new

      Perforated.configure do |config|
        config.cache = custom_cache
        config.json  = custom_parse
      end

      expect(Perforated.cache).to be(custom_cache)
      expect(Perforated.json).to be(custom_parse)
    end
  end

  describe '#json' do
    it 'falls back to core library json' do
      expect(Perforated.json).to eq(JSON)
    end
  end

  describe '#cache' do
    it 'falls back to ActiveSupport::Cache::MemoryStore' do
      expect(Perforated.cache).to be_instance_of(ActiveSupport::Cache::MemoryStore)
    end
  end

  describe '#new' do
    it 'returns a new instance of Perforated::Cache' do
      expect(Perforated.new).to be_instance_of(Perforated::Cache)
    end
  end
end
