#!/usr/bin/env ruby

require 'webrick'

class Printer < WEBrick::HTTPServlet::AbstractServlet

  def do_GET request, response
    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = request.query['text']
    response.cookies.push WEBrick::Cookie.new 'req_time', Time.now.to_s
  end



end

log = File.open "webrick.log", "a+"
alog = [[log, WEBrick::AccessLog::COMBINED_LOG_FORMAT]]

server = WEBrick::HTTPServer.new(
  :Port => 8000,
  :Logger => WEBrick::Log.new(log),
  #:AccessLog => alog
)

server.mount '/print', Printer

trap 'SIGTERM' do
  server.stop
end

trap 'HUP' do
  log.reopen 'webrick.log', 'a+'
end

WEBrick::Daemon.start
server.start
