#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

module CompositeExample
  
  #Component
  class SocialUnit
    
    attr_accessor :parent
    attr_reader :name

    def initialize(name)
      @name = name
      @members = Array.new
    end

    def add_su(su)
      su.parent = self
      @members << su
    end

    def del_su(su)
      @members.delete_if {|inc_su| inc_su.name == su}
    end

    def list_su
      puts "#{@name}:"
      40.times {print "-"}
      print "\n"
      @members.each {|member| member.list_su}
    end
    
    def get_su(su)
      query_result = @members.select {|member| member.name == su}
      query_result[0] unless query_result.empty?
    end
    
  end

  #Leaf
  class Person < SocialUnit

    def initialize(name)
      @name = name
    end
    
    def add_su(su)
      nil
    end

    def del_su(su)
      nil
    end

    def list_su
      puts "    #{@name}"
    end

    def get_su(su)
      self
    end

  end

  #Composite
  class Group < SocialUnit
    
  end

end

nowheresville = CompositeExample::Group.new("Nowheresville")
nowheresville.add_su(CompositeExample::Group.new("The Smiths"))
nowheresville.add_su(CompositeExample::Group.new("The Cooks"))
nowheresville.add_su(CompositeExample::Group.new("The Reys"))

nowheresville.get_su("The Smiths").add_su(CompositeExample::Person.new("John Smith"))
nowheresville.get_su("The Smiths").add_su(CompositeExample::Person.new("Mary Smith"))
nowheresville.get_su("The Cooks").add_su(CompositeExample::Person.new("Bill Cook"))
nowheresville.get_su("The Reys").add_su(CompositeExample::Person.new("Anna Rey"))
nowheresville.get_su("The Reys").add_su(CompositeExample::Person.new("Tom Rey"))

nowheresville.list_su
