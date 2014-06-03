module Perforated
  class Cache
    attr_reader :enumerable, :key_strategy

    def initialize(enumerable, key_strategy = Perforated::Strategy::Default)
      @enumerable   = enumerable
      @key_strategy = key_strategy
    end

    def as_json(options = {})
      keyed   = keyed_enumerable('as-json')
      keys    = keyed.keys.map(&:dup)
      objects = fetch_multi(keys) { |key| keyed[key].as_json }.values

      if options[:rooted]
        Perforated::Rooted.merge(objects)
      else
        objects
      end
    end

    def to_json(options = {})
      keyed   = keyed_enumerable('to-json')
      keys    = keyed.keys.map(&:dup)
      objects = fetch_multi(keys) { |key| keyed[key].to_json }
      concat  = concatenate(objects)

      if options[:rooted]
        Perforated::Rooted.reconstruct(concat)
      else
        concat
      end
    end

    private

    def keyed_enumerable(suffix = '')
      enumerable.each_with_object({}) do |object, memo|
        memo[key_strategy.expand_cache_key(object, suffix)] = object
      end
    end

    def fetch_multi(keys, &block)
      Perforated::Compatibility.fetch_multi *keys, &block
    end

    def concatenate(objects)
      "[#{objects.values.join(',')}]"
    end
  end
end
