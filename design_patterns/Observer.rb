#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby
#Pretty print
require 'colorize'
require 'observer'
module ObserverExample
  
  #Article
  
  class Article
  
    attr_reader :title, :content, :author

    def category
      @category.to_s.capitalize
    end

    def initialize(title, content, author, category = :uncategorized)
      @title, @content, @author, @category = title, content, author, category.downcase.to_sym
    end

    def read(excerpt = nil, read = false)
      if excerpt != :excerpt
        puts title.bold
        puts "by #{author}".cyan
        puts "-"*40
        puts "\n#{content}"
        puts "\nCategory: ".cyan + category + "\n\n"
      elsif excerpt == :excerpt
        print title.bold + " by #{author}"
        print " [Read]".light_black if read
        print "\n"
      end  
      return title
    end

    #Implement ==, eql? and hash for using articles as hash keys
    def ==(other)
      if other.is_a? Article
        title == other.title &&
        content == other.content &&
        author == other.author &&
        category == other.category
      elsif other.is_a? String
        title == other
      else
        false
      end
    end

    alias eql? ==

    def hash
      @title.hash ^ @content.hash ^ @author.hash ^ @category.hash
    end

  end

  #User
  #Gets updates about new articles
  #@articles hash uses articles as keys and values as state
  class User

    attr_reader :name
    
    def initialize(name)
      @articles = {}
      @name = name
    end
    
    #returns false
    def update(article)
      @articles[article] = false
    end

    def read(title = nil)
      if title.nil?
        titles = []
        puts "Articles".red.center(40, "-") + "\n"
        if @articles.empty?
          puts "No articles, come back later"
        else
          @articles.each do |article, read|
            titles << (article.read :excerpt, read)
          end
        end
        print "\n\n"
        return titles
      elsif (title.is_a? String) || (title.is_a? Article)
        @articles.each do |article, read|
          if article == title
            article.read
            @articles[article] = true
            return true
          end
        end
      else
        nil
      end
    end

  end

  #Basic
  class NewsPublisher

    def initialize
      @articles = []
    end

    def write_article(title, content, author, category)
      article = Article.new(title, content, author, category)
      @articles << article
      return article
    end

  end

  #Manual
  class NewsPublisherManual < NewsPublisher

    def initialize
      super
      @subscribers = []
    end

    def subscribe(user)
      @subscribers << user
    end

    def unsubscribe(user)
      @subscribers.delete user
    end
    
    def write_article(title, content, author, category)
      article = super title, content, author, category
      @subscribers.each do |subscriber|
        subscriber.update article
      end
    end

  end

  #Ruby Module
  class NewsPublisherProper < NewsPublisher
    
    include Observable

    def subscribe(user)
      add_observer user
    end

    def unsubscribe(user)
      delete_observer user
    end
    
    def write_article(title, content, author, category)
      article = super title, content, author, category
      changed
      notify_observers article
    end

  end

end

john = ObserverExample::User.new "John"
gmedia = ObserverExample::NewsPublisherProper.new
gmedia.subscribe john
gmedia.write_article("Article A", "Text", "User1", "Stuff")
john.read
gmedia.write_article("Article B", "Another Text", "User1", "Stuff")
john.read.each {|title| john.read title}
gmedia.unsubscribe john
gmedia.write_article("Article C", "Another Text", "User1", "Stuff")
john.read
