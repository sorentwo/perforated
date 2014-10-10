require 'active_support/cache'

module Perforated
  module Strategy
    def self.expand_cache_key(object)
      ActiveSupport::Cache.expand_cache_key(object.cache_key)
    end
  end
end
