#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

require 'socket'

module UDP
  class Server

    #Bind Server to port
    def initialize(port = 40600)
      @server = UDPSocket.new
      @server.bind("127.0.0.1", port)
    end

    #Start Server
    def start
      loop do
        request, client_info = @server.recvfrom(1024*1024, 0)
        client_address, client_port = client_info[3], client_info[1]
        @server.send(response(), 0, client_address, client_port)
      end
    end

    #Form Response
    def response(uri = "index.html")
      begin
        File.open(uri).read
      rescue Exception => e
        e.message
      end
    end

  end

  class Client

    #init Socket
    def initialize
      @server = UDPSocket.new
    end

    #Send Request to Server, get response
    def send_request(request = "", host = "127.0.0.1", port = 40600)
      begin
        @server.connect(host, port)
        @server.send(request, 0)
        response, address = @server.recvfrom(1024*1024)
      rescue Exception => e
        response = e.message
      end
      puts response
    end

  end
end

module TCP
  class Server

    #Bind Server to port
    def initialize(port = 40600)
      @server = TCPServer.open(port)
    end

    def start
      loop do
        client = @server.accept
        client.puts response
        client.close
      end
    end

    def response(uri = "index.html")
      begin
        File.open(uri).read
      rescue Exception => e
        e.message
      end
    end

  end

  class Client

    def send_request(request = "", host = "127.0.0.1", port = 40600)
      begin
        @server = TCPSocket.open(host, port)
        @server.print request    
        response = @server.read
      rescue Exception => e
        response = e.message
      end
      puts response
    end

  end
end

if ARGV[0] == "start"
  if ARGV[1] == "udp"
    (UDP::Server.new).start
  elsif ARGV[1] == "tcp"
    (TCP::Server.new).start  
  else
    (UDP::Server.new).start
  end
end

if ARGV[0] == "send"
  if ARGV[1] == "udp"
    (UDP::Client.new).send_request ARGV[2].to_s
  elsif ARGV[1] == "tcp"
    (TCP::Client.new).send_request ARGV[2].to_s
  else
    (TCP::Client.new).send_request ARGV[1].to_s
  end
end
