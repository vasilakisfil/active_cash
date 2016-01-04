# ActiveCash
Drop in cache strategies for ActiveRecord.

I named the gem ActiveCash in case an official gem arrives with the name
ActiveCache.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_cash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_cash

## Usage
We will add more strategies soon..

#### Existence strategy
``` ruby
class Like < ActiveRecord::Base
  include ActiveCash

         # type      # matched conditions                     # cache name (default is strategy name)
  caches :existence, find_by: [:user_id, :video_id]
  caches :existence, find_by: [:user_id, :video_id, :hidden], name: :hidden
end

# Check if Like exists for specific :user_id, :video_id.
@like = Like.cached_existence_by(user_id: 1, video_id: 2)


# Check if a hidden Like exists for specific :user_id, :video_id.
# not sure what hidden could be but let's say that likes table has a boolean hidden column :)
@like = Like.cached_hidden_by(user_id: 1, video_id: 2, hidden: true)
```

I am open for better naming conventions :)

Cache will be created and updated on every object creation, update and deletion
using an `after_commit` callback. Only a string value is saved (true or false)
in Redis (using [redis-objects](https://github.com/nateware/redis-objects) underneath)
making it extremely efficient.

If you want to have a read-driven cache (which could
enhance your hit ratio depending on your read/writes ratio) you can provide an
empty `update_on` array (by default it includes `[:create, :update, :destroy]`):

``` ruby
class Like < ActiveRecord::Base
  include ActiveCash

         # type      # matched conditions  # updating strategies
  caches :existence, find_by: [:video_id], update_on: []
end

# Check if Like exists for specific :user_id, :video_id.
@like = Like.cached_existence_by(user_id: 1, video_id: 2)


# Check if a hidden Like exists for specific :user_id, :video_id.
# not sure what hidden could be but let's say that likes table has a boolean hidden column :)
@like = Like.cached_hidden_by(user_id: 1, video_id: 2, hidden: true)
```

Now cache will be created and updated ONLY IF there is a reference to Redis.

## Todo
Only existence strategy is supported at the moment but the code is designed to
support other kind of caching strategies as well, like caching the whole object
or some parts of it. Also:

* We should provide named callbacks
* It's super easy to extend for Mongoid
* Add memcached adapter

## Relevant projects
There is [identity_cache](https://github.com/Shopify/identity_cache) built by Shopify.
It uses memcached unfortunately that's why I needed something else.
For existence strategy ActiveCash is definitely better when it comes to space optimizations.
But I would use that if I wanted a full bloated solution.

Unfortunately I couldn't find any other gem for database caching :(

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/vasilakisfil/active_cash/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
