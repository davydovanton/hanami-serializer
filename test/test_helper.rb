$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dry-types'
require 'dry-struct'

require 'hanami/serializer'
require 'hanami/model'

require 'minitest/spec'
require 'minitest/autorun'

module Types
  include Dry::Types.module
end

class User < Hanami::Entity
  attributes do
    attribute :id,         Types::Int
    attribute :name,       Types::String
    attribute :email,      Types::String
    attribute :created_at, Types::Time
  end
end

class UserSerializer < Hanami::Serializer::Base
  attribute :name, Types::String
end

class UserWithAvatarSerializer < Hanami::Serializer::Base
  attribute :name, Types::String

  attribute :avatar, Types::Hash.schema(
    upload_file_name: Types::String,
    upload_file_size: Types::Coercible::Int
  ).default({})
end

class UserWithSelectedFieldsSerializer < Hanami::Serializer::Base
  attribute :id, Types::Int
  attribute :name, Types::String
  attribute :email, Types::String
  attribute :created_at, Types::Time

  serialized_fields [:name]
end

class AvatarSerializer < Hanami::Serializer::Base
  attribute :upload_file_name, Types::String
  attribute :upload_file_size, Types::Coercible::Int
end

class NestedUserSerializer < Hanami::Serializer::Base
  attribute :name, Types::String
  attribute :avatar, AvatarSerializer
end
