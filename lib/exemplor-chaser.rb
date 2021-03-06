#!/usr/bin/env ruby

require 'exemplor'
require 'chaser'

# Exemplor doesn't have passthrough exceptions.

class ExemplorChaser < Chaser

  VERSION = '0.0.2'

  @@test_pattern = 'examples/_examples*.rb' # Fixme what's idiomatic here?
  @@tests_loaded = false

  def self.test_pattern=(value)
    @@test_pattern = value
  end

  def self.load_test_files
    @@tests_loaded = true
    raise "Can't detect any files in test pattern \"#{@@test_pattern}\"#{WINDOZE ? " Are you remembering to use forward slashes?" : ""}" if Dir.glob(@@test_pattern).empty?
    Dir.glob(@@test_pattern).each {|test| require test}
  end

  def self.validate(klass_name, method_name = nil, force = false)
    load_test_files
    klass = klass_name.to_class

    # Does the method exist?
    klass_methods = klass.singleton_methods(false).collect {|meth| "self.#{meth}"}
    if method_name
      if method_name =~ /self\./
        abort "Unknown method: #{klass_name}.#{method_name.gsub('self.', '')}" unless klass_methods.include? method_name
      else
        abort "Unknown method: #{klass_name}##{method_name}" unless klass.instance_methods(false).map{|sym| sym.to_s}.include? method_name
      end
    end

    initial_time = Time.now

    chaser = self.new(klass_name)

    passed = chaser.tests_pass?

    unless force or passed then
      abort "Initial run of examples failed... fix and run chaser again"
    end

    if self.guess_timeout? then
      running_time = Time.now - initial_time
      adjusted_timeout = (running_time * 2 < 5) ? 5 : (running_time * 2).ceil
      self.timeout = adjusted_timeout
    end

    puts "Timeout set to #{adjusted_timeout} seconds."

    if passed then
      puts "Initial examples pass. Let's rumble."
    else
      puts "Initial examples failed but you forced things. Let's rumble."
    end
    puts

    methods = method_name ? Array(method_name) : klass.instance_methods(false) + klass_methods

    counts = Hash.new(0)
    methods.sort.each do |method_name|
      result = self.new(klass_name, method_name).validate
      counts[result] += 1
    end
    all_good = counts[false] == 0

    puts "Chaser Results:"
    puts
    puts "Passed    : %3d" % counts[true]
    puts "Failed    : %3d" % counts[false]
    puts

    if all_good then
      puts "All chasing was thwarted! YAY!!!"
    else
      puts "Improve the tests and try again."
    end

    all_good
  end

  def initialize(klass_name=nil, method_name=nil)
    super
    self.class.load_test_files unless @@tests_loaded
  end

  def tests_pass?
    silence_stream do
      result = Exemplor.examples.run([]).zero?
      ARGV.clear
      result
    end
  end
end
