## v0.10.1 2015-01-05

* Fixed: Safely return an empty hash when there aren't any keys.

## v0.10.0 2014-12-10

* Changed: No longer support batching during serialization. See cb00076 for more
  details about why it was removed.
* Fixed: The result of a yielded block is now used to supply the `cache_key`,
  which is critical for proper serializer caching.

## v0.9.1 2014-10-29

* To preserve the order and limit of ActiveRecord Relations, use of
  `ActiveRecord::Relation#find_in_batches` has been removed in favor of
  `Enumerable#each_slice` during batch caching.

## v0.9.0 2014-10-09

* `as_json` and `to_json` now take a block. The block will be applied to each
  model as it is being cached, allowing for serializers or presenters without
  much additional memory overhead.
* `as_json` has been removed. The overhead from marshalling/unmarshalling had
  enough overhead that it negated the caching benefits.
* Strategies no longer expect a `suffix` property, as anything cached is
  expected to be a JSON string.
* Caching is performed in batches, which can be controlled by passing
  `batch_size` through to `to_json`. Arrays are refined to support
  `find_in_batches` in order to maintain compatibility with ActiveRecord
  Relations. For especially large collections this can provide significant
  memory savings (particularly when paired with passing a block through for
  custom serialization).

## v0.8.2 2014-06-27

* Really force the use of custom `fetch_multi` when using `NullStore`, not just
  when using `MemoryStore`.

## v0.8.1 2014-06-07

* Force use of custom implementation of `fetch_multi`. This makes using the
  default ActiveSupport stores (Memory) possible in versions of Rails between
  4.0 and 4.2.
* Use array extract option support in custom fetch.

## v0.8.0 2014-06-03

* Support reconstructing collections of rooted objects and associations.

## v0.7.0 2013-07-21

* Alter the implementation of `fetch_multi` to return a hash rather than an
  array. This is consistent with the new Dalli implementation, and what should
  be new the Rails implementation.

## v0.6.0 2013-07-13

* Prevent frozen string errors by duplicating hash keys before fetching.
* Use the native cache store's `fetch_multi` implementation if available.

## v0.5.0 2013-07-12

* Initial release!
