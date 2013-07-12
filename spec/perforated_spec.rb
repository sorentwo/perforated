require 'perforated'

describe Perforated do
  after { Perforated.cache = nil }

  describe '#configuration' do
    it 'stores an injected cache object' do
      custom_cache = Object.new

      Perforated.configure do |config|
        config.cache = custom_cache
      end

      Perforated.cache.should be(custom_cache)
    end
  end

  describe '#cache' do
    it 'falls back to ActiveSupport::Cache::MemoryStore' do
      Perforated.cache.should be_instance_of(ActiveSupport::Cache::MemoryStore)
    end
  end
end
