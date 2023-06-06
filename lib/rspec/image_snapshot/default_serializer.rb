# frozen_string_literal: true

require 'awesome_print'

module RSpec
  module ImageSnapshot
    # Serializes values into a MiniMagick::Image.
    class DefaultSerializer
      def dump(value)
        MiniMagick::Image.open(value)
      end
    end
  end
end
