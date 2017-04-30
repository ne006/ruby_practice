#!/usr/bin/env ruby
require 'json'
require 'webrick/websocket'
require 'webrick'
require 'net/http'

class WebConnServlet < WEBrick::Websocket::Servlet

  def socket_open(sock)
    @storage = Queue.new
    sock.puts "Connection established"

  end

  def socket_close(sock)
    @storage = Queue.new
    sock.puts "Connection closed"
  end

  def socket_text(sock, text=nil)
    if (text.nil? || text == '')
      response = Array.new
      (Thread.new do
        until @storage.empty?
          response.push @storage.pop
        end
      end).join
      sock.puts response.to_json
    else
      @storage.enq text
    end
  end

  def do_GET(request, response)
    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = 'GET request successful'
  end

  def do_POST(request, response)
    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = ({data:request.query['data']}).to_json
  end

end

srv = WEBrick::Websocket::HTTPServer.new(:Port => 8080)
srv.mount "/ws", WebConnServlet
trap 'INT' do
  srv.stop
end
srv.start
