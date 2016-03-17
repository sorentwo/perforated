require 'active_support/cache'
require 'json'
require 'perforated/cache'

module Perforated
  extend self

  attr_writer :cache, :json

  def new(*args)
    Perforated::Cache.new(*args)
  end

  def cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
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
