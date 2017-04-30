class A
  @@a=5
  def self.a
    @@a
  end
  def set_a(val)
    @@a = val
  end
  def get_a
    @@a
  end
end

A.send :define_method, :a2, Proc.new {@@a}

obj = A.new

puts "Class method: #{A.a}"
puts "Class method 2: #{A.a2}"
puts "Inst method: #{obj.get_a}"

obj.set_a 7

puts "Inst method: #{obj.get_a}"
puts "Class method: #{A.a}"
puts "Class method 2: #{A.a2}"
