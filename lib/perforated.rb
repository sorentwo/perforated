require 'active_support/cache'
require 'json'
require 'perforated/cache'
require 'perforated/compatibility/fetch_multi'
require 'perforated/rooted'
require 'perforated/strategy/default'
require 'perforated/version'

module Perforated
  def self.cache=(new_cache)
    @cache = new_cache
  end

  def self.cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def self.json=(new_json)
    @json = new_json
  end

  def self.json
    @json ||= JSON
  end

  def self.configure
    yield self
  end

  def self.reset!
    @cache = nil
    @json  = nil
  end
end
