#!/usr/bin/env ruby

require 'socket'

module TCP
  class Server

    #Bind Server to port
    def initialize(port = 40600)
      @server = TCPServer.open(port)
      @sockets = [@server]
    end

    def start
      loop do
        sockets = select(@sockets)[0]
        sockets.each do |socket|
          if socket == @server
            client = @server.accept
            @sockets << client
          else
            response = response (socket.gets.chop)
            puts "#{socket.peeraddr[2]}:#{socket.peeraddr[1]}: #{response}"             
            socket.puts response
            @sockets.delete socket
            socket.close
          end
        end
      end
    end

    def response(uri = nil)
      begin
        uri = "index.html" if uri.nil?
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
        @server.puts request    
        response = @server.read
      rescue Exception => e
        response = e.message
      end
      puts response
    end

  end
end

if ARGV[0] == "start"
    (TCP::Server.new).start
end

if ARGV[0] == "send"
    (TCP::Client.new).send_request ARGV[1].to_s
end
