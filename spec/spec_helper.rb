# frozen_string_literal: true
#
# Bundler bootstrap. We expect the surrounding `bundle exec` to have set up
# the gem environment (pangea-core, terraform-synthesizer, dry-types, etc).
# When pangea-tailscale's own Gemfile/gemset is bundled (via the gem's
# flake), this is a no-op. When the surrounding bundle is a sibling gem's
# (e.g. pangea-datadog) used during fleet-wide bootstrap, $LOAD_PATH is
# already populated with all the dependencies.

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
  track_files 'lib/**/*.rb'
end

lib_path = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require 'rspec'
require 'dry-types'
require 'dry-struct'
require 'terraform-synthesizer'
require 'json'

# pangea-core is the foundation; bundler is responsible for putting it on
# $LOAD_PATH. If this fails, the surrounding bundle is missing pangea-core
# and the developer should `bundle install` against this gem's own
# Gemfile.
require 'pangea-core'
require 'pangea/testing'
require 'pangea-tailscale'

Tailscale = Pangea::Resources::Tailscale unless defined?(Tailscale)

Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }

Pangea::Testing::SpecSetup.configure!
