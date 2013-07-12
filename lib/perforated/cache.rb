require 'json'

module Perforated
  class Cache
    attr_reader :enumerable, :key_strategy

    def initialize(enumerable, key_strategy = Perforated::Strategy::Default)
      @enumerable   = enumerable
      @key_strategy = key_strategy
    end

    def as_json(*)
      keyed = keyed_enumerable('as-json')

      fetch_multi(*keyed.keys) do |key|
        keyed[key].as_json
      end
    end

    def to_json(*)
      keyed = keyed_enumerable('to-json')

      json_objects = fetch_multi(*keyed.keys) do |key|
        keyed[key].to_json
      end

      "[#{json_objects.join(',')}]"
    end

    private

    # Backward compatible implementation of fetch multi.
    def fetch_multi(*names)
      options = {}
      results = Perforated.cache.read_multi(*names, options)

      names.map do |name|
        results.fetch(name) do
          value = yield name
          Perforated.cache.write(name, value, options)
          value
        end
      end
    end

    def keyed_enumerable(suffix = '')
      enumerable.inject({}) do |memo, object|
        memo[key_strategy.expand_cache_key(object, suffix)] = object
        memo
      end
    end
  end
end
