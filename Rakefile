require "bundler/gem_tasks"
require 'rake/testtask'

desc 'Default Task'
task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/test_*.rb'
end
