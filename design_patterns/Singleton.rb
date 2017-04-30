#!/usr/bin/env ruby
require 'singleton'
require 'minitest/autorun'

=begin
Singleton
  -Ensures only one instance of a class is actually made
  -Creates a global access point to class instance
=end

#Manual
module SingletonExample

    def self.included(base)
      base.class.instance_variable_set("@instance",nil)
      base.send :private_class_method, :new, :allocate
      base.class.send :define_method, :instance, Proc.new {@instance || @instance = new}
    end

end

#Singleton class
class Sing1
  include SingletonExample
end

#Child Singleton Class
class Sing2 < Sing1
end

#Singleton class (Ruby Module)
class Sing3
  include Singleton
end

#Child Singleton Class (Ruby Module)
class Sing4 < Sing3
end

#Test
class TestSingleton < Minitest::Test

  def setup
    @sing1_a = Sing1.instance
    @sing1_b = Sing1.instance
    @sing2_a = Sing2.instance
  end

  def test_only_one_instance
    assert @sing1_a.__id__ == @sing1_b.__id__
  end

  def test_only_one_instance_per_class
    assert @sing1_a.__id__ != @sing2_a.__id__
  end

end

#Test (Ruby Module)
class TestSingletonNative < Minitest::Test

  def setup
    @sing3_a = Sing3.instance
    @sing3_b = Sing3.instance
    @sing4_a = Sing4.instance
  end

  def test_only_one_instance
    assert @sing3_a.__id__ == @sing3_b.__id__
  end

  def test_only_one_instance_per_class
    assert @sing3_a.__id__ != @sing4_a.__id__
  end

end
