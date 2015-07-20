# require 'simplecov'

require 'rubygems'
#uncomment the following line to use spork with the debugger
# require 'spork/ext/ruby-debug'

# Spork.prefork do
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
ENV["RAILS_ROOT"] = File.expand_path("../dummy", __FILE__)
ENV["TEASPOON_RAILS_ENV"] = File.expand_path("../dummy/config/environment.rb", __FILE__)
ENV["TEASPOON_DEVELOPMENT"] = "true"

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  # factory girl
  config.include FactoryGirl::Syntax::Methods

  # database cleaner

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
