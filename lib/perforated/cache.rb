module Perforated
  class Cache
    attr_reader :enumerable, :key_strategy

    def initialize(enumerable, key_strategy = Perforated::Strategy::Default)
      @enumerable   = enumerable
      @key_strategy = key_strategy
    end

    def as_json(*)
      keyed = keyed_enumerable('as-json')
      keys  = keyed.keys.map(&:dup)

      fetch_multi(keys) { |key| keyed[key].as_json }.values
    end

    def to_json(*)
      keyed   = keyed_enumerable('to-json')
      keys    = keyed.keys.map(&:dup)
      objects = fetch_multi(keys) { |key| keyed[key].to_json }

      "[#{objects.values.join(',')}]"
    end

    private

    def keyed_enumerable(suffix = '')
      enumerable.inject({}) do |memo, object|
        memo[key_strategy.expand_cache_key(object, suffix)] = object
        memo
      end
    end

    def fetch_multi(keys, &block)
      Perforated::Compatibility.fetch_multi *keys, &block
    end
  end
end
