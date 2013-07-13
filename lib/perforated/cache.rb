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

      Perforated::Compatibility.fetch_multi(*keys) do |key|
        keyed[key].as_json
      end
    end

    def to_json(*)
      keyed = keyed_enumerable('to-json')
      keys  = keyed.keys.map(&:dup)

      json_objects = Perforated::Compatibility.fetch_multi(*keys) do |key|
        keyed[key].to_json
      end

      "[#{json_objects.join(',')}]"
    end

    private

    def keyed_enumerable(suffix = '')
      enumerable.inject({}) do |memo, object|
        memo[key_strategy.expand_cache_key(object, suffix)] = object
        memo
      end
    end
  end
end
