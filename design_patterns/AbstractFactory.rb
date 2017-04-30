#!/usr/bin/env ruby
require 'minitest/autorun'

=begin
Abstract Factory
	-Provides an interface for creating families of objects without specifying their classes
=end

module AbstractFactoryExample

	class GenericFactory
		def create_product
			return "Factory is generic, no product"
		end
	end

	class GenericProduct
	end

	class AutomobileProduct < GenericProduct
	end

	class ComputerProduct < GenericProduct
	end

	class AutomobileFactory < GenericFactory
		def create_product
			return AutomobileProduct.new
		end
	end

	class ComputerFactory < GenericFactory
		def create_product
			return ComputerProduct.new
		end
	end

end

class TestAbstractFactory < Minitest::Test

	def setup
		@auto_factory = AbstractFactoryExample::AutomobileFactory.new
		@pc_factory = AbstractFactoryExample::ComputerFactory.new
	end

	def test_auto_factory_produces_autos
		assert_equal @auto_factory.create_product.class, AbstractFactoryExample::AutomobileProduct
	end

	def test_computer_factory_produces_pcs
		assert_equal @pc_factory.create_product.class, AbstractFactoryExample::ComputerProduct
	end

end
