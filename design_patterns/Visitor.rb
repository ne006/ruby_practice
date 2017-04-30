#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

require 'json'

module VisitorExample
  
  #Implementation of #accept
  module Visitable

    def accept visitor
      visitor.visit self
    end

  end

  #Sample Visitor
  class FormatVisitor

    #Pick a specific implementation based on class of the subject
    def self.visit subject
      method_name = "visit_#{subject.class.name.split('::').last}".to_sym
      __send__ method_name, subject
    end

    def self.visit_Article subject
      "#{subject.name.center(40,"-")}\n#{subject.body}"
    end

    def self.visit_JSONContainer subject
      JSON.pretty_generate(JSON.parse subject.json)
    end

  end

  #Article subject class
  class Article

    include Visitable

    attr_reader :name, :body
      
    def initialize name, body
      @name, @body = name, body
    end

  end

  #JSONContainer subject class
  class JSONContainer

    include Visitable

    attr_reader :json

    def initialize collection
      @json = JSON.generate (collection)
    end

  end

end

article = VisitorExample::Article.new "A header", "A body"
json = VisitorExample::JSONContainer.new ({:a=>1,:b=>2,:c=>{:a=>5,:b=>6}})
puts VisitorExample::FormatVisitor.visit article
puts VisitorExample::FormatVisitor.visit json
