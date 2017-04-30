#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

module DecoratorExample
  
  #Base class
  class Text
    
    attr_reader :title, :body, :author

    def initialize(title, body, author)
      @title, @body, @author = title, body, author
    end

    def render
      puts @body
    end

  end
   
  #Feature 1
  class TitleDecorator < SimpleDelegator
    
    def initialize(text)
      @text = text
      super
    end

    def render
      puts @text.title
      40.times {print "-"}
      puts "\n"
      @text.render
    end

  end

  #Feature 2
  class AuthorDecorator < SimpleDelegator
    
    def initialize(text)
      @text = text
      super
    end

    def render
      @text.render
      puts "\nby #{@text.author}"
    end

  end

end

text = DecoratorExample::TitleDecorator.new(
        DecoratorExample::AuthorDecorator.new(
          DecoratorExample::Text.new(
            "Some stuff", 
            "Stuff happened", 
            "Annonymous"
          )
        )
       )
text.render
