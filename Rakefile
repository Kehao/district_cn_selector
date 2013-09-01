#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }

require "district_cn_selector/version"
version = DistrictCnSelector::VERSION


task :build do
  system "mkdir -p pkg"
  system "gem build district_cn_selector.gemspec"
end

task :install => :build do
  system "gem install district_cn_selector-#{version}.gem"
end

task :release => :build do
  puts "Tagging #{version}..."
  system "git tag -a #{version} -m 'Tagging #{version}'"
  puts "Pushing to Github..."
  system "git push --tags"
  puts "Pushing to rubygems.org..."
  system "gem push district_cn_selector-#{version}.gem"
end

require 'rspec/core'
require 'rspec/core/rake_task'

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')
task :default => :spec

