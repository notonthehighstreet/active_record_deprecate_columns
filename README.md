# ActiveRecordDeprecateColumns

[![Build Status](https://travis-ci.org/notonthehighstreet/active_record_deprecate_columns.svg?branch=master)](https://travis-ci.org/notonthehighstreet/active_record_deprecate_columns)
[![Depfu](https://badges.depfu.com/badges/cd0479da3674d517a19d67b4e19e661f/overview.svg)](https://depfu.com/github/notonthehighstreet/active_record_deprecate_columns?project_id=5010)
[![Depfu](https://badges.depfu.com/badges/cd0479da3674d517a19d67b4e19e661f/count.svg)](https://depfu.com/github/notonthehighstreet/active_record_deprecate_columns?project_id=5010)

An ActiveRecord extension gem that allows you to deprecate columns before you
delete them. This will allow you to double-check that a column definitely isn't
in use before it's gone. The deprecated columns won't appear in `#to_json` calls.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_deprecate_columns'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_deprecate_columns

## Usage

In an initializer extend ActiveRecord with the ActiveRecordDeprecateColumns module:

```ruby
ActiveRecord::Base.extend ActiveRecordDeprecateColumns
```

In your model, call `deprecate_column` with the column name you want to deprecate:

```ruby
class User < ActiveRecord::Base
  deprecate_column "my_old_column"
end

User.new.my_old_column # => nil
```

Optional named parameters are `with_block:` and `fallback:`.

- `with_block` accepts a `Proc` object that is called whenever you try to access the deprecated column
- `fallback` is a message to send to the AR object when it receives the deprecated column name.

For instance, you can fall back to a different column, but use the block to log a deprecation warning.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_record_deprecate_columns/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
