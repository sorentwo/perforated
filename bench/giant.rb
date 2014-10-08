require 'bundler'

Bundler.setup

require 'benchmark'
require 'perforated'
require 'active_support/core_ext/object'
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
  x.report('memory-1-to') { perforated.to_json }
  x.report('memory-2-to') { perforated.to_json }

  x.report('memory-1-as') { perforated.as_json }
  x.report('memory-2-as') { perforated.as_json }

  Perforated.configure do |config|
    config.cache = ActiveSupport::Cache::RedisStore.new(host: 'localhost', db: 5)
  end

  Perforated.cache.clear

  x.report('redis-1-to') { perforated.to_json }
  x.report('redis-2-to') { perforated.to_json }

  x.report('redis-1-as') { perforated.as_json }
  x.report('redis-2-as') { perforated.as_json }
end
