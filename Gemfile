# frozen_string_literal: true

source "https://rubygems.org"

# Suppress lockfile on Bundler 4+ (gem: do not pin the graph). No-op on
# Bundler that lacks the DSL (Ruby 2.x CI). Do not combine with
# ruby/setup-ruby `bundler-cache: true` — that action cats Gemfile.lock
# after `bundle lock` and fails when no file is written (Windows 3.2+,
# where setup-ruby installs Bundler ~> 4).
lockfile false if respond_to?(:lockfile)

gemspec

# logger left the default-gem set in Ruby 4; file/log-adapter services
# require it. Not declared in the gemspec: the logger gem itself requires
# Ruby >= 2.5 and would break resolution on 2.0–2.4.
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('4')

  gem "logger", '~> 1.0'
end

# rake 13 requires Ruby >= 2.3
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.3")

  gem "rake", '~> 13.0'
else

  gem "rake", '~> 12.3'
end

gem "test-unit", '~> 3.0'
