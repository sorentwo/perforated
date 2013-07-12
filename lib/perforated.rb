require 'active_support/cache'
require 'json'
require 'perforated/cache'
require 'perforated/strategy/default'
require 'perforated/version'

module Perforated
  def self.cache=(new_cache)
    @cache = new_cache
  end

  def self.cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def self.configure
    yield self
  end
end
