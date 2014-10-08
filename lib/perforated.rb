require 'active_support/cache'
require 'json'
require 'perforated/cache'
require 'perforated/compatibility/find_each'
require 'perforated/compatibility/fetch_multi'
require 'perforated/rooted'
require 'perforated/strategy/default'
require 'perforated/version'

module Perforated
  extend self

  def new(*args)
    Perforated::Cache.new(args)
  end

  def cache=(new_cache)
    @cache = new_cache
  end

  def cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def json=(new_json)
    @json = new_json
  end

  def json
    @json ||= JSON
  end

  def configure
    yield self
  end

  def reset!
    @cache = nil
    @json  = nil
  end
end
