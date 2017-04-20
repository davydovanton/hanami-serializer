module Hanami
  module Serializer
    module Action
      def send_json(response, status: 200)
        self.status = status
        self.body = JSON.generate(response)
      end

      def serializator
        @serializator ||=
          begin
            namespases = self.class.name.split('::')
            namespases[1] = 'Serializators'
            Hanami::Utils::Class.load(namespases.join('::'))
          end
      end
    end
  end
end
