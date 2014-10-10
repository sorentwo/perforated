require 'perforated/rooted'
require 'perforated/strategy'
require 'perforated/compatibility/find_in_batches'
require 'perforated/compatibility/fetch_multi'

module Perforated
  class Cache
    using Perforated::Compatibility::FindInBatches

    attr_accessor :enumerable, :strategy

    def initialize(enumerable, strategy = Perforated::Strategy)
      @enumerable = enumerable
      @strategy   = strategy
    end

    def to_json(rooted: false, batch_size: 1000, &block)
      results = []

      enumerable.find_in_batches(batch_size: batch_size) do |subset|
        keyed = key_mapped(subset)

        results << fetch_multi(keyed) do |key|
          if block_given?
            (yield keyed[key]).to_json
          else
            keyed[key].to_json
          end
        end.values
      end

      reconstruct(rooted, results)
    end

    private

    def key_mapped(subset)
      subset.each_with_object({}) do |object, memo|
        memo[strategy.expand_cache_key(object)] = object
      end
    end

    def fetch_multi(keyed, &block)
      keys = keyed.keys.map(&:dup)

      Perforated::Compatibility.fetch_multi(*keys, &block)
    end

    def reconstruct(rooted, results)
      if rooted
        Perforated::Rooted.reconstruct(concatenate(results))
      else
        concatenate(results)
      end
    end

    def concatenate(values)
      "[#{values.join(',')}]"
    end
  end
end
