# frozen_string_literal: true
source "https://rubygems.org"

gemspec

raw_rails_version = ENV.fetch("RAILS_VERSION", "4.2")
rails_version = "~> #{raw_rails_version}"

gem "activesupport", rails_version
gem "activemodel", rails_version
gem "activerecord", rails_version, group: :test

group :benchmarks do
  gem "sqlite3"
  gem "pg", "0.21"

  gem "memory_profiler"
  gem "ruby-prof"
  gem "ruby-prof-flamegraph"

  gem "benchmark-ips"
  gem "active_model_serializers"
  gem "terminal-table"
  gem "fast_jsonapi"
end

group :test do
  gem "faker"
end

group :development do
  gem "byebug"
  gem "rake"
  gem "rspec", "~> 3.0"
  gem "rake-compiler"
end
