require 'json'

module Hanami
  module Serializer
    class Base < Dry::Struct
      constructor_type :weak

      class << self
        def serialized_fields(attributes)
          @serialized_fields = attributes
        end

        def current_serialized_fields
          @serialized_fields
        end
      end

      def initialize(attributes)
        attributes = Hash(attributes)
        super
      end

      def to_json(_ = nil)
        JSON.generate(attributes_for_serialize(to_h))
      end
      alias_method :call, :to_json

      def serialized_fields
        self.class.current_serialized_fields
      end

      private

      def attributes_for_serialize(attributes)
        return attributes unless serialized_fields
        attributes.select do |key, _|
          serialized_fields.include?(key)
        end
      end
    end
  end
end
