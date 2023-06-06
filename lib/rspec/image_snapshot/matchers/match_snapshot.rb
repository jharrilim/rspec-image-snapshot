# frozen_string_literal: true

require 'fileutils'
require 'rspec/image_snapshot/default_serializer'
require 'mini_magick'

module RSpec
  module ImageSnapshot
    module Matchers
      # RSpec matcher for snapshot testing
      class MatchSnapshot
        attr_reader :actual, :expected

        def initialize(metadata, snapshot_name, config)
          @metadata = metadata
          @snapshot_name = snapshot_name
          @config = config
          @serializer = serializer_class.new
          @snapshot_path = File.join(snapshot_dir, @snapshot_name)
          @pending_snapshot_path = File.join(snapshot_dir,
                                             "pending_#{@snapshot_name}")
          create_snapshot_dir
        end

        private def serializer_class
          if @config[:snapshot_serializer]
            @config[:snapshot_serializer]
          elsif RSpec.configuration.snapshot_serializer
            RSpec.configuration.snapshot_serializer
          else
            DefaultSerializer
          end
        end

        private def snapshot_dir
          if RSpec.configuration.snapshot_dir.to_s == 'relative'
            File.dirname(@metadata[:file_path]) << '/__snapshots__'
          else
            RSpec.configuration.snapshot_dir
          end
        end

        private def create_snapshot_dir
          return if Dir.exist?(File.dirname(@snapshot_path))

          FileUtils.mkdir_p(File.dirname(@snapshot_path))
        end

        def matches?(actual)
          @actual = serialize(actual)

          write_snapshot

          @expected = read_snapshot

          matches = @actual == @expected

          if matches
            File.delete(@pending_snapshot_path) if pending_review?
          else
            @actual.write(@pending_snapshot_path)
          end

          matches
        end

        # === is the method called when matching an argument
        alias === matches?
        alias match matches?

        private def serialize(value)
          return value if value.is_a?(MiniMagick::Image)

          @serializer.dump(value)
        end

        private def write_snapshot
          return unless should_write?

          RSpec.configuration.reporter.message(
            "Snapshot written: #{@snapshot_path}"
          )
          @actual.write(@snapshot_path)
        end

        private def should_write?
          update_snapshots? || !File.exist?(@snapshot_path)
        end

        private def pending_review?
          File.exist?(@pending_snapshot_path)
        end

        private def update_snapshots?
          ENV.fetch('UPDATE_SNAPSHOTS', nil)
        end

        private def read_snapshot
          MiniMagick::Image.open(@snapshot_path)
        end

        def description
          "to match a snapshot against the image: \"#{@snapshot_path}\""
        end

        def diffable?
          false
        end

        def failure_message
          "Snapshot did not match. Review #{@pending_snapshot_path}"
        end

        def failure_message_when_negated
          "Snapshot did not match. Review #{@pending_snapshot_path}"
        end
      end
    end
  end
end
