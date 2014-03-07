module Perforated
  module Compatibility
    def self.fetch_multi(*names, &block)
      if Perforated.cache.respond_to?(:fetch_multi)
        Perforated.cache.fetch_multi(*names, &block)
      else
        custom_fetch_multi(*names, &block)
      end
    end

    # Backward compatible implementation of fetch multi.
    def self.custom_fetch_multi(*names)
      options = {}
      results = Perforated.cache.read_multi(*names, options)

      names.each_with_object({}) do |(name, _), memo|
        memo[name] = results.fetch(name) do
          value = yield name
          Perforated.cache.write(name, value, options)
          value
        end
      end
    end
  end
end
