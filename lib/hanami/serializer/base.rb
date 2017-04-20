require 'json'

module Hanami
  module Serializer
    class Base < Dry::Struct
      constructor_type :weak

      def initialize(attributes)
        attributes = Hash(attributes)
        super
      end

      def to_json(_ = nil)
        JSON.generate(to_h)
      end
      alias_method :call, :to_json
    end
  end
end
