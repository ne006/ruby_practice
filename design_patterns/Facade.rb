#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

#originaly Adapter
module FacadeExample
  
  #Adaptee
  class HashDataSource    
    
    def initialize(source)
      @source = source
    end

    def get_data(query = "", by_key = true)
      @source.select do |key, value|
        if(query == "" or query.nil? or query == "*")
          true
        elsif(by_key)
           key == query or key == query.to_sym
        else
           value == query
        end
      end  
    end

  end

  #Client
  class PlainTextPrinter
 
    def render(header, body)
      puts "#{header}\n"
      40.times {print "-"}
      puts "\n#{body}"
    end

  end

  #Adapter (the cherry on the cake)
  class HashToPlainAdapter
    
    def initialize(source)
      @source = source
    end

    def get_doc(title)
      doc = @source.get_data("*",false).select do |key, value|
        value.split("\n")[0] == title
      end
      doc.first[1].split("\n",2) unless doc.nil?
    end

  end

  #The cream - Facade
  class ArticlePrinter
  
    def initialize(source, output_format = 'plain')
      
      @source = FacadeExample::HashToPlainAdapter.new(
        FacadeExample::HashDataSource.new(source)
      )
      @printer = FacadeExample::PlainTextPrinter.new

    end

    def print(article)
      
      @printer.render(@source.get_doc(article)[0], @source.get_doc(article)[1]) unless article.nil?

    end

  end

end

hash = {
  :pop_science => "Quantum stuff discovered\nA group of scientists recently discovered a piece of quantum stuff",
  :news => "Shit happens\nSome shit happened, according to Brusseles News Agency",
  :bar_commercial => "Drunken Sailor Pub is now open!\n24/7 open\nnice atmosphere\n'n other shit"
}

art_print = FacadeExample::ArticlePrinter.new(hash)
art_print.print("Quantum stuff discovered")
