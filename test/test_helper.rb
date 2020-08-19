# frozen_string_literal: true

require 'bundler/setup'
require 'minitest/autorun'
require 'active_support'
require 'active_record'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

$:.unshift File.expand_path('../lib', __dir__)
require 'as_json'

# Load all files inside the support directory
Dir['./test/support/**/*.rb'].each { |f| require f }

class ActiveSupport::TestCase
  self.test_order = :random
end
