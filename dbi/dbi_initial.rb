#!/usr/bin/env ruby
require 'dbi'
begin
  conn = DBI.connect("DBI:Pg:ruby_practice:localhost", "postgres", "postgres")
rescue DBI::DatabaseError => e
  puts e.message
  conn.disconnect if @conn
end
row = conn.select_all("SELECT * from contact")
puts "Test: #{row[0].inspect}"
