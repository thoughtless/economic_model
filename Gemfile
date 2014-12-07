source "https://rubygems.org"

gem "foreman"

# These gems are not required for the library, but are used in some supporting
# way.
gem "rake"

group :development do
  gem "pry"
end

group :test do
  gem "rspec", "~> 3.1"
  gem "timecop"

  # Used so we can load `test.env` directly from spec/spec_helper.rb rather than
  # having to run tests with a bug ugly command like this:
  #     bundle exec forman run --env test.env rspec spec
  gem "dotenv"
end
