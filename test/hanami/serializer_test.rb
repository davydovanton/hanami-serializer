require 'test_helper'

describe Hanami::Serializer do
  let(:serializer) { UserSerializer.new(object) }

  describe '#to_json' do
    describe 'works with hash' do
      let(:object) { { id: 1, name: 'Anton' } }

      it { serializer.to_json.must_equal '{"name":"Anton"}' }
      it { serializer.call.must_equal '{"name":"Anton"}' }
      it { JSON.generate(serializer).must_equal '{"name":"Anton"}' }
    end

    describe 'works with hanami-entity' do
      let(:object) { User.new(id: 1, name: 'Anton', email: 'test@site.com', created_at: Time.now) }

      it { serializer.to_json.must_equal '{"name":"Anton"}' }
      it { serializer.call.must_equal '{"name":"Anton"}' }
      it { JSON.generate(serializer).must_equal '{"name":"Anton"}' }
    end
  end
end
