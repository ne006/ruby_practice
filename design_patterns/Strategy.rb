#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

require 'json'

module StrategyExample
  
  #Abstract rendering Strategy, defines interface and such
  class Renderer

    def self.render(data)
      raise NotImplementedError, "Abstract class, use something concrete, alright?"
    end

  end
  
  class UglyJSONRenderer < Renderer

    def self.render(data)
      JSON.generate(data)
    end

  end

  class PrettyJSONRenderer < Renderer

    def self.render(data)
      JSON.pretty_generate(data)
    end

  end

  #Client, uses Strategies
  class DataPackager

    attr_accessor :renderer

    def initialize(renderer = UglyJSONRenderer)
      @renderer = renderer
    end

    def render(data)
      @renderer.render data
    end

  end

end

a = {
  "a": 1,
  "b": 2,
  "c": {
    "a": 4,
    "b": 5
  }
}
dp = StrategyExample::DataPackager.new
puts dp.render a
puts
dp.renderer = StrategyExample::PrettyJSONRenderer
puts dp.render a
puts 
