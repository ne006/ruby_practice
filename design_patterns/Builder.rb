#!/usr/bin/env ruby
require 'minitest/autorun'

=begin
Builder
  -Allows construction of complex objects from parts
  -These parts' construction is isolated from construction of the whole objects
=end

module BuilderExample

  #Abstract data source
  #Implementations should return header and body of the data
  class DataSource

    def get_data(doc)
      raise NotImplementedError, "Abstract Class"
    end

  end

  #Abstract data formatter
  class DataFormatter

    def output_data(header, body)
      raise NotImplementedError, "Abstract Class"
    end

  end

  #Director part of the pattern
  class DocRenderer

    def initialize(data_source, data_formatter)
      raise TypeError, "Data Source doesn't conform to interface" unless
        data_source.respond_to? :get_data
      raise TypeError, "Data Formatter doesn't conform to interface" unless
        data_formatter.respond_to? :output_data
      @data_source, @data_formatter = data_source, data_formatter
    end

    def render(doc)
      data = @data_source.get_data(doc)
      @data_formatter.output_data(data[:header], data[:body])
    end

  end

  #Docs stored in a hash
  class HashDataSource < DataSource

    def initialize(location)
      @location = location
    end

    def get_data(doc)
      return {:header => @location[doc][:header], :body => @location[doc][:body]}
    end

  end

  #Docs output as plain text
  class PlainDataFormatter < DataFormatter

    def output_data(header, body)
      return "#{header}\n\n#{body}"
    end

  end

end

class TestBuilder < Minitest::Test

  def setup
      @docs = {
        :an_article=>{:header=>"Article",:body=>"Sample text\nMore Text\n\nby annonymous"}
      }
      @doc_source = BuilderExample::HashDataSource.new(@docs)
      @doc_printer = BuilderExample::PlainDataFormatter.new
      @doc_renderer = BuilderExample::DocRenderer.new(@doc_source, @doc_printer)
  end

  def test_invalid_data_source
    begin
      BuilderExample::DocRenderer.new(4,@doc_printer)
    rescue TypeError => e
      assert_equal e.message, "Data Source doesn't conform to interface"
    end
  end

  def test_invalid_data_formatter
    begin
      BuilderExample::DocRenderer.new(@doc_source,"test")
    rescue TypeError => e
      assert_equal e.message, "Data Formatter doesn't conform to interface"
    end
  end

  def test_doc_is_rendered
    assert_equal (@doc_renderer.render :an_article), "#{@docs[:an_article][:header]}\n\n#{@docs[:an_article][:body]}"
  end

end
