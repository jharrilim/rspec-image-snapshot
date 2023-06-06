# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'rspec/image_snapshot/default_serializer'
require 'mini_magick'

describe RSpec::ImageSnapshot::Matchers do
  describe 'unit tests' do
    # rubocop:disable Lint/ConstantDefinitionInBlock
    # rubocop:disable RSpec/LeakyConstantDeclaration
    class TestClass
      include RSpec::ImageSnapshot::Matchers
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock
    # rubocop:enable RSpec/LeakyConstantDeclaration
    subject { TestClass.new }

    describe '.match_snapshot' do
      let(:current_example) { object_double(RSpec.current_example) }
      let(:rspec_metadata) { { foo: :bar } }
      let(:snapshot_name) { 'excellent_test_snapshot_name' }

      before do
        allow(RSpec).to receive(:current_example).and_return(current_example)
        allow(current_example).to receive(:metadata).and_return(rspec_metadata)
        allow(RSpec::ImageSnapshot::Matchers::MatchSnapshot).to receive(:new)
      end

      context 'when config is passed' do
        let(:config) { { foo: :bar } }

        before do
          subject.match_snapshot(snapshot_name, config)
        end

        it 'creates a MatchSnapshot instance with the name and config' do
          expect(RSpec::ImageSnapshot::Matchers::MatchSnapshot).to(
            have_received(:new).with(rspec_metadata, snapshot_name, config)
          )
        end
      end

      context 'when config is omitted' do
        before do
          subject.match_snapshot(snapshot_name)
        end

        it 'creates a MatchSnapshot instance with the name and config' do
          expect(RSpec::ImageSnapshot::Matchers::MatchSnapshot).to(
            have_received(:new).with(rspec_metadata, snapshot_name, {})
          )
        end
      end
    end

    describe '.snapshot' do
      let(:current_example) { object_double(RSpec.current_example) }
      let(:rspec_metadata) { { foo: :bar } }
      let(:snapshot_name) { 'excellent_test_snapshot_name' }

      before do
        allow(RSpec).to receive(:current_example).and_return(current_example)
        allow(current_example).to receive(:metadata).and_return(rspec_metadata)
        allow(RSpec::ImageSnapshot::Matchers::MatchSnapshot).to receive(:new)
      end

      context 'when config is passed' do
        let(:config) { { foo: :bar } }

        before do
          subject.snapshot(snapshot_name, config)
        end

        it 'creates a MatchSnapshot instance with the name and config' do
          expect(RSpec::ImageSnapshot::Matchers::MatchSnapshot).to(
            have_received(:new).with(rspec_metadata, snapshot_name, config)
          )
        end
      end

      context 'when config is omitted' do
        before do
          subject.snapshot(snapshot_name)
        end

        it 'creates a MatchSnapshot instance with the name and config' do
          expect(RSpec::ImageSnapshot::Matchers::MatchSnapshot).to(
            have_received(:new).with(rspec_metadata, snapshot_name, {})
          )
        end
      end
    end
  end

  describe 'integration tests' do
    context 'when UPDATE_SNAPSHOTS is unset' do
      context 'with a JPEG photo' do
        let(:photo) { MiniMagick::Image.open('spec/fixtures/images/jpeg.jpg') }

        context 'and a matching snapshot' do
          it 'has a snapshot file and equality passes' do
            expect(photo).to match_snapshot('jpeg.jpg')

            snapshot_exists = File.exist?(
              'spec/rspec/snapshot/__snapshots__/jpeg.jpg'
            )
            expect(snapshot_exists).to be true
          end
        end

        it 'doesn\'t match a different photo snapshot' do
          expect do
            expect(photo).to match_snapshot('jpeg_incorrect.png')
          end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
        end
      end
    end

    context 'when UPDATE_SNAPSHOTS is set' do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('UPDATE_SNAPSHOTS').and_return('true')
      end

      context 'with a JPEG photo' do
        let(:photo) { MiniMagick::Image.open('spec/fixtures/images/jpeg.jpg') }

        context 'and a matching snapshot that has a pending file' do
          before do
            allow(File).to receive(:delete).and_return(true)
            expect(photo).to match_snapshot('pending-test-jpeg.jpg')
          end

          it 'deletes the pending file' do
            expect(File).to have_received(:delete)
          end
        end
      end
    end
  end
end
