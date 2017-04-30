#!/usr/bin/env ruby
require 'minitest/autorun'

module AdapterExample

  #Adaptee
  class HashDataSource

    def initialize(source = Hash.new)
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

end

class TestAdapter < Minitest::Test

  def setup
    hash = {
      :pop_science => "Quantum stuff discovered\nA group of scientists recently discovered a piece of quantum stuff",
      :news => "Shit happens\nSome shit happened, according to Brusseles News Agency",
      :bar_commercial => "Drunken Sailor Pub is now open!\n24/7 open\nnice atmosphere\n'n other shit"
    }

    @hash_source = AdapterExample::HashDataSource.new(hash)
    @adapter = AdapterExample::HashToPlainAdapter.new(@hash_source)
    @renderer = AdapterExample::PlainTextPrinter.new
  end

  def test_hash_source
    assert_equal ({:pop_science=>"Quantum stuff discovered\nA group of scientists recently discovered a piece of quantum stuff"}),
      @hash_source.get_data(:pop_science, true)
  end

  def test_renderer
    @renderer.render("Quantum stuff discovered","A group of scientists recently discovered a piece of quantum stuff")
    assert_output("") {"Quantum stuff discovered\n#{"".center(40,"-")}A group of scientists recently discovered a piece of quantum stuff"}
  end

  def test_adapter
    assert_equal ["Quantum stuff discovered","A group of scientists recently discovered a piece of quantum stuff"],
      @adapter.get_doc("Quantum stuff discovered")
  end

end
