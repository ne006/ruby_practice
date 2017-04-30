#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

module CoRExample

  module Chainable

    def chain(link)
      @next = link
    end

    def method_missing(method, *args, &block)
      if @next.nil?
        return
      else
        puts "#{self.class}: Delegating request #{method} to a #{@next.class}"
        @next.__send__(method, *args, &block)
      end
    end

  end

  class Db
    
    include Chainable
    
    def query(title)
      return "An article", "Some shit happened"
    end

  end

  class View
    
    include Chainable
    
    def render(title, body)
      puts title
      40.times {print "-"}
      print "\n"
      puts body
      print "\n"
    end

  end

  class App

    include Chainable
    
    def initialize
      @db = Db.new
      @view = View.new

      chain(@view)
      @view.chain(@db)
    end

    def process_request(title)
      q_res = query(title)
      render(q_res[0], q_res[1])
    end

  end

end

app = CoRExample::App.new
app.process_request(:title)
