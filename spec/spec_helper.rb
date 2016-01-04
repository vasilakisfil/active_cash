$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'active_cash'
require 'active_record'
require 'factory_girl'
require 'database_cleaner'
require 'fakeredis/rspec'
require 'test_after_commit'
require 'pry'

DatabaseCleaner.strategy = :truncation

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/factories/**/*.rb'].each { |f| require f }

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

load File.dirname(__FILE__) + '/schema.rb'
require File.dirname(__FILE__) + '/models.rb'

RSpec.configure do |c|
  c.include Helpers
  c.include Rspec::AdapterHelpers
end
