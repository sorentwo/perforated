[![Build Status](https://travis-ci.org/sorentwo/perforated.png?branch=master)](https://travis-ci.org/sorentwo/perforated)
[![Code Climate](https://codeclimate.com/github/sorentwo/perforated.png)](https://codeclimate.com/github/sorentwo/perforated)
[![Gem Version](https://badge.fury.io/rb/perforated.png)](http://badge.fury.io/rb/perforated)

# Perforated

The most expensive part of serving a JSON request is converting the serialized
records into JSON. Perforated cache handles the messy task of storing and
retrieving all JSON for a particular set of models as effeciently as possible.
It achieves this several ways:

1. Storing final json output, not marshalled objects
2. Retrieving the json for as many objects at once as is possible, and then
   filling in the remaining json as if it was always there. This is where the
   term 'perforated' comes from.

## Configuration

Perforated is mildly configurable, mostly to allow for easy testing. However,
if you are so inclined you can customize the backing cache. The default cache
store is `ActiveSupport::Cache::MemoryStore`, which is fast but has no
persistence.

Within a Rails project the simplest option is to lock with the Rails cache.

```ruby
Perforated.configure do |config|
  config.cache = Rails.cache
end
```

Outside of a rails project you may wish to use something like Dalli by itself:

```ruby
Perforated.configure do |config|
  config.cache = ActiveSupport::Cache::DalliStore.new('localhost')
end
```

## Usage

Wrap any collection that you want to serialize in a cache instance and then
call `as_json` or `to_json` on it. Not much to it!

```ruby
perforated = Perforated::Cache.new(my_collection)
perforated.to_json
perforated.as_json
```

Any objects that have been cached will be retrieved unaltered. Any missing
objects (cache misses) will be serialized, inserted back into the collection,
and written into the cache.

### Custom Key Strategy

The default cache key strategy is to delegate back to each object to construct
its own cache key. This is useful for an object like a serializer that can
implement it's own `cache_key` method.

```ruby
class MySerializer
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def cache_key
    [object, scope]
  end
end
```

However, if you are just serializing models or objects that don't have a custom
cache method you can provide a custom key caching strategy.

```ruby
module CustomStrategy
  def self.expand_cache_key(object, suffix)
    [object.id, object.updated_at, suffix].join('/')
  end
end

perforated = Perforated::Cache.new(array, CustomStrategy)
```

## Installation

Add this line to your application's Gemfile:

    gem 'perforated'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install perforated

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
