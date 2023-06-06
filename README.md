# RSpec::ImageSnapshot

Adds image snapshot testing to Rspec which work on `MiniMagick::Image`s.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-image-snapshot'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install rspec-snapshot
```

## Usage

The gem provides `match_snapshot` and `snapshot` RSpec matchers which take
a snapshot name as an argument like:

```ruby
# match_snapshot
expect(image).to match_snapshot('resized-image.jpg')

# match argument with snapshot
expect(formatter).to have_received(:image).with(snapshot('input.png'))
```

When a test is run using a snapshot matcher and a snapshot file does not exist
matching the passed name, the test value encountered will be stored in your
snapshot directory as the file: `#{snapshot_name}`.

When a test is run using a snapshot matcher and a snapshot file exists matching
the passed name, then the test value encountered will be serialized and
compared to the snapshot file contents. If the values match your test passes,
otherwise it fails.

### Testing that an image matches a snapshot

```ruby
RSpec.describe MyImageProcessor do
  describe '#process' do
    it 'generates a thumbnail' do
      image = subject.process('path/to/image.png')
      expect(image).to match_snapshot('thumbnail')
    end
  end
end
```

### UPDATE_SNAPSHOTS environment variable

Occasionally you may want to regenerate all encountered snapshots for a set of
tests. To do this, just set the UPDATE_SNAPSHOTS environment variable for your
test command.

Update all snapshots

```shell
UPDATE_SNAPSHOTS=true bundle exec rspec
```

Update snapshots for some subset of tests

```shell
UPDATE_SNAPSHOTS=true bundle exec rspec spec/foo/bar
```

## Configuration

Global configurations for rspec-snapshot are optional. Details below:

```ruby
RSpec.configure do |config|
  # The default setting is `:relative`, which means snapshot files will be
  # created in a '__snapshots__' directory adjacent to the spec file where the
  # matcher is used.
  #
  # Set this value to put all snapshots in a fixed directory
  config.snapshot_dir = "spec/fixtures/snapshots"
end
```

## Development

### Initial Setup

Install a current version of ruby (> 2.6) and bundler. Then install gems

```shell
bundle install
```

### Linting

```shell
bundle exec rubocop
```
### Unit tests

```shell
bundle exec rspec
```

### Interactive console with the gem code loaded

```shell
bin/console
```

### Rake commands

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
[https://github.com/jharrilim/rspec-image-snapshot](https://github.com/jharrilim/rspec-image-snapshot).

A big thanks to the original author [@yesmeck](https://github.com/yesmeck) and [@levinmr](https://github.com/levinmr).
