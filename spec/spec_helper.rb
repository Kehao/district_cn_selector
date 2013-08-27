require 'rubygems'
ENV['RAILS_ENV'] ||= 'test'

require "rails"
require "active_record"
require "district_cn"
silence_warnings do
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Base.logger = Logger.new(nil)
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
end

ActiveRecord::Base.connection.instance_eval do
  create_table :companies do |t|
    t.string :name
    t.string :loc_code
    t.string :another_code
    t.timestamps
  end
end

class Company < ActiveRecord::Base
  attr_accessor :region_code

  act_as_area_field :region_code,:loc_code
  validates :region_code, presence: true
  validates :loc_code, presence: true
end

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'factory_girl_rails'


Rails.backtrace_cleaner.remove_silencers!
Capybara.javascript_driver = :webkit

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end
