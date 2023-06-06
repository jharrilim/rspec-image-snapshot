# frozen_string_literal: true

require 'rspec/image_snapshot/matchers/match_snapshot'

module RSpec
  module ImageSnapshot
    # rubocop:disable Style/Documentation
    module Matchers
      def match_snapshot(snapshot_name, config = {})
        MatchSnapshot.new(RSpec.current_example.metadata,
                          snapshot_name,
                          config)
      end

      alias snapshot match_snapshot
    end
    # rubocop:enable Style/Documentation
  end
end

RSpec.configure do |config|
  config.include RSpec::ImageSnapshot::Matchers
end
