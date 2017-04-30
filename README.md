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
* `#send_json` - casts object as json and sets it to action `body`
* `#serializator` - returns serializator class for current action

#### Example
```ruby
# api/controllers/controller/index.rb

module Api::Controllers::Controller
  class Show
    include Api::Action
    include Hanami::Serializer::Action

    def call(params)
      object = repo.find(params[:id])

      serializator # => Api::Serializators::Controller::Show

      object = serializator.new(object)
      send_json(object)

      # simular to
      #
      #   self.status = 200
      #   self.body = JSON.generate(object)
    end
  end
end
```

#### Custom serializator class
If you want to use custom serializator class you can override `#serializator` method like this:

```ruby
# api/controllers/controller/index.rb

module Api::Controllers::Controller
  class Update
    include Api::Action
    include Hanami::Serializer::Action

    def call(params)
      serializator # => Api::Serializators::Controller::Create

      # code
    end

    def serializator
      @serializator ||= Api::Serializators::Controller::Create
    end
  end
end
```

### Serializators
Create simple serializator for each action:

```ruby
# api/serializators/controller/index.rb

module Api::Serializators
  module Controller
    class Show < Hanami::Serializer::Base
      # put here attributes needful for action
      attribute :id,   Types::Id
      attribute :name, Types::UserName
    end
  end
end
```

And after that you can use it like a usual ruby object:
```ruby
user = User.new(id: 1, name: 'anton', login: 'davydovanton')

serializator = Api::Serializators::Contributors::Index.new(user)

serializator.to_json        # => '{ "id":1, "name": "anton" }'
serializator.call           # => '{ "id":1, "name": "anton" }'
JSON.generate(serializator) # => '{ "id":1, "name": "anton" }'
```

### Nested
You can use nested data structures. You have 2 ways how to use it

#### Type
We can create new [hash type](http://dry-rb.org/gems/dry-types/hash-schemas/) of attribute:

```ruby
class UserWithAvatarSerializer < Hanami::Serializer::Base
  attribute :name, Types::String

  attribute :avatar, Types::Hash.schema(
    upload_file_name: Types::String,
    upload_file_size: Types::Coercible::Int
  )
end
```

#### Serializator
We can user other serializator as a type for attribute:

```ruby
class AvatarSerializer < Hanami::Serializer::Base
  attribute :upload_file_name, Types::String
  attribute :upload_file_size, Types::Coercible::Int
end

class NestedUserSerializer < Hanami::Serializer::Base
  attribute :name, Types::String
  attribute :avatar, AvatarSerializer
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hanami-serializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

