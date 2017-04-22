require 'test_helper'

describe Hanami::Serializer do
  let(:serializer) { UserSerializer.new(object) }

  describe '#to_json' do
    describe 'works with empty hash' do
      let(:object) { {} }

      it { serializer.to_json.must_equal '{"name":null}' }
      it { serializer.call.must_equal '{"name":null}' }
      it { JSON.generate(serializer).must_equal '{"name":null}' }
    end

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

    describe 'works with nested data' do
      let(:serializer) { UserWithAvatarSerializer.new(object) }

      describe 'for emplt nested data' do
        let(:object) { { id: 1, name: 'Anton', email: 'test@site.com', created_at: Time.now } }

        it { serializer.to_json.must_equal '{"name":"Anton","avatar":{}}' }
        it { serializer.call.must_equal '{"name":"Anton","avatar":{}}' }
        it { JSON.generate(serializer).must_equal '{"name":"Anton","avatar":{}}' }
      end

      describe 'for emplt nested data' do
        let(:object) do
          {
            id: 1,
            name: 'Anton',
            email: 'test@site.com',
            created_at: Time.now,
            avatar: {
              upload_file_name: 'test.jpg',
              upload_file_size: 10,
              upload_updated_at: Time.now
            }
          }
        end

        it { serializer.to_json.must_equal '{"name":"Anton","avatar":{"upload_file_name":"test.jpg","upload_file_size":10}}' }
        it { serializer.call.must_equal '{"name":"Anton","avatar":{"upload_file_name":"test.jpg","upload_file_size":10}}' }
        it { JSON.generate(serializer).must_equal '{"name":"Anton","avatar":{"upload_file_name":"test.jpg","upload_file_size":10}}' }
      end
    end

    describe 'works with nested serializer' do
      let(:serializer) { NestedUserSerializer.new(object) }

      describe 'for emplt nested data' do
        let(:object) { { id: 1, name: 'Anton', email: 'test@site.com', created_at: Time.now } }

        it { serializer.to_json.must_equal '{"name":"Anton","avatar":null}' }
        it { serializer.call.must_equal '{"name":"Anton","avatar":null}' }
        it { JSON.generate(serializer).must_equal '{"name":"Anton","avatar":null}' }
      end

      describe 'for emplt nested data' do
        let(:object) do
          {
            id: 1,
            name: 'Anton',
            email: 'test@site.com',
            created_at: Time.now,
            avatar: {
              upload_file_name: 'test.jpg',
              upload_file_size: 10,
              upload_updated_at: Time.now
            }
          }
        end

        it { serializer.to_json.must_equal '{"name":"Anton","avatar":{"upload_file_name":"test.jpg","upload_file_size":10}}' }
        it { serializer.call.must_equal '{"name":"Anton","avatar":{"upload_file_name":"test.jpg","upload_file_size":10}}' }
        it { JSON.generate(serializer).must_equal '{"name":"Anton","avatar":{"upload_file_name":"test.jpg","upload_file_size":10}}' }
      end
    end
  end
end
