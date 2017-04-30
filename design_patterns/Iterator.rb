#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

module IteratorExample

  class ObjectArray

    include Enumerable

    def <<(item)
      new_key = "@a"
      new_key = instance_variables.sort.last.succ.to_s if instance_variables.sort.last
      instance_variable_set(new_key ,item)
    end

    def >>(key)
      instance_variable_get "@#{key}"
    end

    def each
      pos = "a"
      until instance_variables.last.succ.to_s == "@#{pos}"
        yield instance_variable_get "@#{pos}"
        pos.succ!
      end      
    end

  end

  class ObjectArrayIterator

    def initialize(array)
      @array = array
      @pos = "a"
    end

    def first
      @array >> "a"
    end
    
    def next
      @pos.succ!
      @array >> @pos
    end

    def last?
      @array.instance_variables.last.to_s == "@#{@pos}"
    end

  end

end

arr = IteratorExample::ObjectArray.new
arr << 3
arr << 1
arr << "ty"
arr << "t56"
arr << "last one"

puts "Iterator\n\n"

arrIter = IteratorExample::ObjectArrayIterator.new(arr)
puts arrIter.first
puts arrIter.next
until arrIter.last?
  puts arrIter.next
end

puts "\nEnumerable\n\n"

arr.each {|item| puts item}
