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
  def self.expand_cache_key(object)
    "perf-#{object}"
  end
end

perforated = Perforated::Cache.new((0..20_000).map { |i| Structure.new(i) }, Strategy)

Benchmark.bm do |x|
  GC.disable
  puts "Total Objects: #{ObjectSpace.count_objects[:TOTAL]}"

  x.report('memory-1') { perforated.to_json }
  x.report('memory-2') { perforated.to_json }

  puts "Total Objects: #{ObjectSpace.count_objects[:TOTAL]}"

  Perforated.configure do |config|
    config.cache = ActiveSupport::Cache::RedisStore.new(host: 'localhost', db: 5)
  end

  Perforated.cache.clear

  GC.enable
  GC.start
  GC.disable

  x.report('redis-1') { perforated.to_json }
  x.report('redis-2') { perforated.to_json }

  puts "Total Objects: #{ObjectSpace.count_objects[:TOTAL]}"
end
