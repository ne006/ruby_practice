#!/usr/bin/env ruby

class App

  def call env
    request = Rack::Request.new env

    response = Rack::Response.new
    response.write "Hey"
    response.write response_to(request)
    response.write response.inspect
    response.finish
  end

  def response_to request

    request.params

  end

end
