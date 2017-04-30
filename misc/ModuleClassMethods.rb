module A 
  def a 
    true 
  end
end 

class B 
  extend A 
end

module C 
  def self.included(base)
    base.class.send :define_method, :c, proc {
      base.class_variable_set "@@c", true 
    }
    base.send :define_method, :c_get, proc {
      @@c 
    }
  end 
end 

class D 
  include C 
end 

D.c 
D.new.c_get