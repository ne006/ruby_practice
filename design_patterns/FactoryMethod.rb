#!/usr/bin/env ruby
require 'minitest/autorun'

=begin
Factory Method
	-Defines an interface for creation of objects
	-Lets it's Creator subclasses decide what class Product should be
	-Eliminates the need to bind application-specific classes
=end

module FactoryMethodExample

	class GenericApplication
		def initialize
      @page = gen_page
      view
		end

    def view
      puts @page.render
    end

    def gen_page
      return GenericPage
    end

	end

	class GenericPage
		def render
			return "Page is generic"
		end
	end

##---------------------------------------------------------

	class SomeApp < GenericApplication
		def gen_page
			return SomePage.new
		end
	end

	class SomePage < GenericPage
		def render
			return "Some page"
		end
	end

##---------------------------------------------------------

	class AnotherApp < GenericApplication
		def gen_page
			return AnotherPage.new
		end
	end

	class AnotherPage < GenericPage
		def render
			return "Another page"
		end
	end

end

class TestFactoryMethod < Minitest::Test

	def setup
		@someapp = FactoryMethodExample::SomeApp.new
		@anotherapp = FactoryMethodExample::AnotherApp.new
	end

	def test_some_app_returns_some_page
		assert_equal @someapp.gen_page.class, FactoryMethodExample::SomePage
	end

	def test_another_app_returns_another_page
		assert_equal @anotherapp.gen_page.class, FactoryMethodExample::AnotherPage
	end

end
