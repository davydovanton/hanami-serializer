# NOT MAINTAINED

# Hanami::Serializer

Simple solution for serializing you data in hanami apps.

* [Installation](#installation)
* [Usage](#usage)
  * [Action helpers](#action-helpers)
    * [Example](#example)
    * [Custom serializer class](#custom-serializer-class)
  * [Serializers](#serializers)
    * [Nested](#nested)
      * [Type](#type)
      * [Serializer](#serializer)
    * [Shared](#shared)
* [Contributing](#contributing)
* [License](#license)

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

Create and add `serializers` folder to application:

```ruby
# apps/api/application.rb

load_paths << %w[
  controllers
  serializers
]
```

## Usage
### Action helpers
* `#send_json` - casts object as json and sets it to action `body`
* `#serializer` - returns serializer class for current action

#### Example
```ruby
# api/controllers/controller/index.rb

module Api::Controllers::Controller
  class Show
    include Api::Action
    include Hanami::Serializer::Action

    def call(params)
      object = repo.find(params[:id])

      serializer # => Api::Serializers::Controller::Show

      object = serializer.new(object)
      send_json(object)

      # simular to
      #
      #   self.status = 200
      #   self.body = JSON.generate(object)
    end
  end
end
```

#### Custom serializer class
If you want to use custom serializer class you can override `#serializer` method like this:

```ruby
# api/controllers/controller/index.rb

module Api::Controllers::Controller
  class Update
    include Api::Action
    include Hanami::Serializer::Action

    def call(params)
      serializer # => Api::Serializers::Controller::Create

      # code
    end

    def serializer
      @serializer ||= Api::Serializers::Controller::Create
    end
  end
end
```

### Serializers
Create simple serializer for each action:

```ruby
# api/serializers/controller/index.rb

module Api::Serializers
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

serializer = Api::Serializers::Contributors::Index.new(user)

serializer.to_json        # => '{ "id":1, "name": "anton" }'
serializer.call           # => '{ "id":1, "name": "anton" }'
JSON.generate(serializer) # => '{ "id":1, "name": "anton" }'
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

#### Serializer
We can user other serializer as a type for attribute:

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

### Shared
You can share your serializer code using general classes. For this you need:

1. Create model-specific serializer
2. Use oop inheritance for sharing model-specific attributes

```ruby
# api/serializers/user.rb

module Api::Serializers
  class User < Hanami::Serializer::Base
    attribute :name, Types::UserName
  end
end
```

```ruby
# api/serializers/users/index.rb
module Api::Serializers
  module Users
    class Index < User
      # put here other attributes needful for action
      attribute :id, Types::Id
    end
  end
end

# api/serializers/users/show.rb
module Api::Serializers
  module Users
    class Show < User
      # put here other attributes needful for action
      attribute :posts, Types::Posts
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davydovanton/hanami-serializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

