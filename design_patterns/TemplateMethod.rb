#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

require 'colorize'

module TemplateMethodExample

  #Abstract class
  class ArticleFinder

    def upsert(article)
      @data ||= []
      @data << article
    end

    #Template method
    def view(name)
      begin     
        article = query(name)
        f_article = format(article)
        f_article = post_format(f_article)
        output(f_article)
      rescue Exception => e
        puts e.message
      end
    end

    def query(name)
      @data.find {|article| article[:name] == name}
    end

    def format(article)
      "#{article[:name].center(40,"-")}\n#{article[:body]}"
    end

    def post_format(f_article)
      f_article
    end

    def output(f_article)
      puts f_article
    end

  end

  #Concrete class
  class ArticleFinderWithEnding < ArticleFinder
    
    def post_format(f_article)
      "#{f_article}\n" + "-"*40
    end    
    
  end

end

af = TemplateMethodExample::ArticleFinderWithEnding.new
a = {
  :name => "BREAKING NEWS: Shit happened", 
  :body => "But nobody gives a damn"
}
b = {
  :name => "BREAKING NEWS: More shit happened", 
  :body => "But nobody gives a damn again"
}
af.upsert a
af.upsert b

af.view('BREAKING NEWS: More shit happened')
