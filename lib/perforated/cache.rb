require 'perforated/rooted'
require 'perforated/strategy'
require 'perforated/compatibility/fetch_multi'

module Perforated
  class Cache
    attr_accessor :enumerable, :strategy

    def initialize(enumerable, strategy = Perforated::Strategy)
      @enumerable = enumerable
      @strategy   = strategy
    end

    def to_json(options = {}, &block)
      keyed   = keyed_enumerable('to-json')
      objects = fetch_multi(keyed) do |key|
        if block_given?
          (yield keyed[key]).to_json
        else
          keyed[key].to_json
        end
      end.values

      if options[:rooted]
        Perforated::Rooted.reconstruct(concatenate(objects))
      else
        concatenate(objects)
      end
    end

    private

    def keyed_enumerable(suffix = '')
      enumerable.each_with_object({}) do |object, memo|
        memo[strategy.expand_cache_key(object, suffix)] = object
      end
    end

    def fetch_multi(keyed, &block)
      keys = keyed.keys.map(&:dup)

      Perforated::Compatibility.fetch_multi(*keys, &block)
    end

    def concatenate(values)
      "[#{values.join(',')}]"
    end
  end
end
