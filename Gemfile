source 'https://rubygems.org'

# Declare your gem's dependencies in graspi.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# view libs
gem 'therubyracer', platforms: :ruby

# dev
group :development do

  gem "rails", "~> 4.2.3"
  gem "sqlite3"
  gem "thin"

  # views
  gem 'haml-rails'

  # dev
  gem 'awesome_print'

  # errors
  gem 'better_errors'
  gem 'binding_of_caller'

  # logging
  gem 'quiet_assets'

  # debugging
  gem 'byebug'

end

# testing
group :development, :test do

  # rspec
  gem 'rspec-rails'
  gem 'capybara'

  # data & mocking
  gem 'factory_girl_rails'
  gem 'database_cleaner'

end