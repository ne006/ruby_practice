#!/usr/bin/env ruby
require 'yaml'
require 'minitest/autorun'

=begin
Prototype
  -Create objects by copying from Prototype instance
  -Reduce subclassing
  -Gives an opportunity to define and load classes at runtime
=end

module PrototypeExample

  #Classes config
  VALS = YAML.load("---
  :type1:
    :attr1: 1
    :attr2: 1
  :type2:
    :attr1: 2
    :attr2: 2")

  #Hash of prototypes
  PROTOTYPES = Hash.new

  class Stuff

    attr_accessor :attr1, :attr2
    attr_reader :type

    def initialize(type)
      if PrototypeExample::VALS[type]
        @type, @attr1, @attr2 = type, PrototypeExample::VALS[type][:attr1], PrototypeExample::VALS[type][:attr2]
      else
        raise RuntimeError, "Type not found"
      end
    end

    def report
      puts "Stuff of #{@type} with attr1 #{@attr1}, attr2 #{@attr2}"
    end

  end

  def self.init
    PrototypeExample::VALS.each do |type, params|
      PrototypeExample::PROTOTYPES[type] = PrototypeExample::Stuff.new(type)
    end
  end

end

class TestPrototype < Minitest::Test

  def setup
    PrototypeExample.init
  end

  def test_prototypes_are_initialized
    PrototypeExample::VALS.each do |type, attrs|
      assert PrototypeExample::PROTOTYPES[type]
      attrs.each do |attr, value|
        assert_equal PrototypeExample::PROTOTYPES[type].send(attr), value
      end
    end
  end

  def test_dynamic_class
    #Add class config
    PrototypeExample::VALS[:type3] = {attr1: 3, attr2: 3}
    PrototypeExample.init
    #Test
    PrototypeExample::VALS.each do |type, attrs|
      assert PrototypeExample::PROTOTYPES[type]
      attrs.each do |attr, value|
        assert_equal PrototypeExample::PROTOTYPES[type].send(attr), value
      end
    end
  end

  def test_object_inherits_from_prototype
    #Instantiate object
    proto = PrototypeExample::PROTOTYPES[:type2]
    obj = proto.dup
    #Test
    assert_equal proto.type, obj.type
    assert_equal proto.attr1, obj.attr1
    assert_equal proto.attr2, obj.attr2
  end

end
