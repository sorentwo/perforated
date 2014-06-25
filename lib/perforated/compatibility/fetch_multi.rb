require 'active_support/core_ext/array/extract_options'

module Perforated
  module Compatibility
    def self.fetch_multi(*names, &block)
      if supports_fetch_multi?
        Perforated.cache.fetch_multi(*names, &block)
      else
        custom_fetch_multi(*names, &block)
      end
    end

    def self.custom_fetch_multi(*names)
      options = names.extract_options!
      results = Perforated.cache.read_multi(*names, options)

      names.each_with_object({}) do |(name, _), memo|
        memo[name] = results.fetch(name) do
          value = yield name
          Perforated.cache.write(name, value, options)
          value
        end
      end
    end

    def self.supports_fetch_multi?
      cache = Perforated.cache

      cache.respond_to?(:fetch_multi) && !(
        cache.instance_of?(ActiveSupport::Cache::MemoryStore) ||
        cache.instance_of?(ActiveSupport::Cache::NullStore)
      )
    end
  end
end
