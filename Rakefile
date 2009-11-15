begin
  require 'jeweler'
  require File.dirname(__FILE__) + "/lib/exemplor-chaser.rb"
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "exemplor-chaser"
    gemspec.summary = "Runner for chaser against exemplor"
    gemspec.description = "Lightweight mutation testing against exemplor"
    gemspec.email = "andrew.j.grimm@gmail.com"
    gemspec.authors = ["Andrew Grimm", "Ryan Davis", "Eric Hodel", "Kevin Clark"]
    gemspec.add_dependency('exemplor', '>= 2000.2.0')
    gemspec.version = ExemplorChaser::VERSION
    gemspec.homepage = "http://andrewjgrimm.wordpress.com/2009/11/08/declare-war-on-everything-with-chaser/"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end
