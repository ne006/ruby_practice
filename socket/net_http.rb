#!/usr/bin/env ruby

require 'net/http'

rq = Net::HTTP.new("www.ya.ru")
hd, body = rq.get("/")
puts hd.inspect
puts
puts body

require 'open-uri'

open("https://www.ya.ru") {|f| puts f.read}
