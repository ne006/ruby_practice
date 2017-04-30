#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

module BridgeExample

  module ArticleWithDashSeparator

    def render
        puts @title
        40.times {print "-"}
        puts @body
    end

  end

  module ArticleWithoutSeparator

    def render
        puts "#{@title}\n"
        puts @body
    end

  end

  class Article

    def initialize(title, body)
      @title, @body = title, body
    end

    def stylize(style = nil)
      case style
        when :dash
          extend ArticleWithDashSeparator
        when :space
          extend ArticleWithoutSeparator
        else
          extend ArticleWithoutSeparator
      end
    end

  end
    
end

a = BridgeExample::Article.new("article a","sample text")
b = BridgeExample::Article.new("article b","more sample text")

a.stylize(:dash)
b.stylize(:space)

a.render
b.render
