module Perforated
  module Strategy
    def self.expand_cache_key(object, suffix = '')
      args = object.cache_key + [suffix]

      ActiveSupport::Cache.expand_cache_key(args)
    end
  end
end
