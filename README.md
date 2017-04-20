# Hanami::Serializer

Simple solution for serializing you data in hanami apps.

## Why?

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hanami-serializer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hanami-serializer

Create 'Types' module:

```ruby
# lib/types.rb

module Types
  include Dry::Types.module
end
```

Create and add `serializators` folder to application:

```ruby
# apps/api/application.rb

load_paths << %w[
  controllers
  serializators
]
```

## Usage

### Action helpers
### Serializators

## TODO
* tests for all helpers

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hanami-serializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

