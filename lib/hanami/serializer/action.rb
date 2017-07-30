module Hanami
  module Serializer
    module Action
      def send_json(response, status: 200)
        self.status = status
        self.body = JSON.generate(response)
      end

      def serializer
        @serializer ||=
          begin
            namespases = self.class.name.split('::')
            namespases[1] = 'serializers'
            Hanami::Utils::Class.load(namespases.join('::'))
          end
      end

      alias :serializator :serializer
    end
  end
end
