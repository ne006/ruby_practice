#!/usr/bin/env ruby
require 'pry'

class SquareMeter
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def to_s
    "#{@value} sq.m"
  end

  def +(other)
    if other.is_a? SquareMeter
      SquareMeter.new(self.value + other.value)
    elsif other.is_a? Integer
      SquareMeter.new(self.value + other)
    else
      if other.respond_to? :coerce
        a, b = other.coerce(self)
        a + b
      else
        raise TypeError, "Can't slap this BS to this!"
      end
    end
  end

  def coerce(other)
    [SquareMeter.new(other), self]
  end

end

binding.pry
