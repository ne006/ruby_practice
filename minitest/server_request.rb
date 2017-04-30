#!/usr/bin/env ruby
require 'minitest'
require 'minitest/autorun'
require_relative 'multiplex_server_thread_powered_mt.rb'

class TestServer < Minitest::Test

  def setup

    @srv = TCP::Server.new
    @srv.start

    @client = TCP::Client.new

  end

  def test_server_request

    assert_equal @client.send_request("../socket/index.html") /ru, File.open("../socket/index.html").read

  end

end
