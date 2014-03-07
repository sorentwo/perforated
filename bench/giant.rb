require 'bundler'

Bundler.setup

require 'benchmark'
require 'dalli'
require 'perforated'
require 'active_support/core_ext/object'
require 'active_support/cache/dalli_store'
require 'redis'
require 'redis-activesupport'

Structure = Struct.new(:id) do
  def to_json
    { id: id, answers: %w[a b c d e f g], tags: [] }.to_json
  end
end

module Strategy
  def self.expand_cache_key(object, suffix)
    "perf-#{object}"
  end
end

perforated = Perforated::Cache.new((0..20_000).map { |i| Structure.new(i) }, Strategy)

Benchmark.bm do |x|
  x.report('memory-1') { perforated.to_json }
  x.report('memory-2') { perforated.to_json }

  Perforated.configure do |config|
    config.cache = ActiveSupport::Cache::RedisStore.new(host: 'localhost', db: 5)
  end

  Perforated.cache.clear

  x.report('redis-1') { perforated.to_json }
  x.report('redis-2') { perforated.to_json }

  Perforated.configure do |config|
    config.cache = ActiveSupport::Cache::DalliStore.new('localhost')
  end

  Perforated.cache.clear

  x.report('dalli-1') { perforated.to_json }
  x.report('dalli-2') { perforated.to_json }
end
