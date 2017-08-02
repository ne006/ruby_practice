require 'pry'

def say_my_name
  puts self.inspect
  puts "You're god damn right"
end

say_my_name

class A
  say_my_name
end