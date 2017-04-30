#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

module MediatorExample

  class Message

    attr_reader :from, :to

    def initialize(from, to, message)
      @from, @to, @message = from, to, message
    end

    def process
      puts "From: #{@from}"
      puts "To: #{@to}"
      40.times {print "-"}
      puts "\n#{@message}\n\n"
    end

  end

  class Terminal

    def initialize(name, router)
      @name, @router = name, router
      @router.register self
    end

    def name
      @name
    end

    def send(to, message)
      @router.route(Message.new(@name, to, message))
    end

    def receive(message)
      message.process
    end
      
  end

  class Router
    
    def initialize(name)
      @name = name
      @rtable ||= {}
    end

    def name
      @name
    end

    def rtable
      @rtable
    end

    def register(client)
      @rtable[client.name.to_sym] = client
    end

    def connect(to)
      to.register self
      register to
    end

    def route(message, prev = "")
      @rtable.each do |name, client|
        if name.to_s == message.to
          client.receive message
          return true
        elsif (client.respond_to? :route) && name.to_s != prev
          return true if client.route(message, @name)
        end        
      end
      return false
    end

  end

end

a = MediatorExample::Router.new("A_router")
a1 = MediatorExample::Terminal.new("A1",a)
a2 = MediatorExample::Terminal.new("A2",a)
a3 = MediatorExample::Terminal.new("A3",a)

b = MediatorExample::Router.new("B_router")
b.connect a
b1 = MediatorExample::Terminal.new("B1",b)
b2 = MediatorExample::Terminal.new("B2",b)

a1.send("A2","Hi!")
a3.send("B2","Hey there!")
b1.send("A3", "Ahoy!")
