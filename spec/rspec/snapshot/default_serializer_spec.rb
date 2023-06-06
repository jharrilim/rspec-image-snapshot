# frozen_string_literal: true

require 'spec_helper'

describe RSpec::ImageSnapshot::DefaultSerializer do
  subject { described_class.new }

  describe '#dump' do
    let(:param) { 'some/fake/path' }
    let(:expected) { instance_double(MiniMagick::Image) }

    before do
      allow(MiniMagick::Image).to receive(:open).and_return(expected)
      @actual = subject.dump(param)
    end

    it 'calls .open on MiniMagick::Image with the param' do
      expect(MiniMagick::Image).to have_received(:open).with(param)
    end

    it 'returns the result from awesome_print' do
      expect(@actual).to be(expected)
    end
  end
end
