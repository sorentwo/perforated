require 'perforated/rebuilder'
require 'perforated/strategy'

module Perforated
  class Cache
    attr_accessor :enumerable, :strategy

    def initialize(enumerable, strategy = Perforated::Strategy)
      @enumerable = enumerable
      @strategy   = strategy
    end

    def to_json(rooted: false, &block)
      keyed   = key_mapped(enumerable, &block)
      results = fetch_multi(keyed) { |key| keyed[key].to_json }.values

      rebuild(results, rooted)
    end

    private

    def key_mapped(subset)
      subset.each_with_object({}) do |object, memo|
        object = yield(object) if block_given?
        memo[strategy.expand_cache_key(object)] = object
      end
    end

    def fetch_multi(keyed, &block)
      keys = keyed.keys.map(&:dup)

      return {} unless keys.any?

      Perforated.cache.fetch_multi(*keys, &block)
    end

    def rebuild(results, rooted)
      Perforated::Rebuilder.new(results).rebuild(rooted: rooted)
    end
  end
end
