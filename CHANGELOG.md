## Version 0.7.0

* Alter the implementation of `fetch_multi` to return a hash rather than an
  array. This is consistent with the new Dalli implementation, and what should
  be new the Rails implementation.

## Version 0.6.0

* Prevent frozen string errors by duplicating hash keys before fetching.
* Use the native cache store's `fetch_multi` implementation if available.

## Version 0.5.0

* Initial release!
