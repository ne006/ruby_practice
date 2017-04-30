#!/usr/bin/env ruby

require 'socket'

module TCP
  class Server

    #Bind Server to port
    def initialize(port = 40600)
      @server = TCPServer.open(port)
    end

    def start
      @running = true
      puts "Server has started on #{@server.addr[3]}:#{@server.addr[1]}"
      Thread.new do

        loop do
          if @running
            client = @server.accept
            Thread.new(client) do |client|
              request = client.gets.chop.split(" ")[1].sub("/","")
              response = response (request)
              puts "#{client.peeraddr[2]}:#{client.peeraddr[1]} > #{request}"
              puts "#{client.peeraddr[2]}:#{client.peeraddr[1]} < #{response}"
              client.puts response
              client.close
            end
          else
            break
          end
        end

      end
    end

    def response(uri = nil)
      begin
        uri = "index.html" if (uri.nil? || uri == "")
        File.open(uri).read
      rescue Exception => e
        e.message
      end
    end

    def stop
      @running = false
      puts "Server on #{@server.addr[3]}:#{@server.addr[1]} has been stopped"
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

while cmd = gets
  cmd.chop!
  if cmd
    begin
      case cmd
        when "start"
          srv = TCP::Server.new unless srv
          srv.start
        when "stop"
          srv.stop
        when "exit"
          break
        else
          (TCP::Client.new).send_request cmd
        end
    rescue Exception => e
      puts e.message
    end
  end
end
