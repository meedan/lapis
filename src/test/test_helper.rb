ENV['RAILS_ENV'] ||= 'test'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/test_unit'
require 'mocha/test_unit'

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  include SampleData

  # This will run before any test

  def setup
    Rails.cache.clear if File.exists?(File.join(Rails.root, 'tmp', 'cache'))
  end

  # This will run after any test

  def teardown
    WebMock.reset!
    WebMock.allow_net_connect!
  end
end
