#!/usr/bin/env ruby
require_relative 'dbi_conn'

conn = DBconn.new('localhost','5432','Pg','postgres','postgres','ruby_practice')
puts "Initial select"
conn.execute "select * from contact" do |rows|
  rows.each do |row|
    row.to_h.each_value {|val| print "#{val} "}
    puts
  end
end
puts

puts "Performing insert"
rowset = conn.execute("insert into contact (lst_name, fst_name, mdl_name)
  values ('Ульянов','Кирилл','Евгеньевич') returning *") {|rows| break rows.first.to_h}
conn.commit
a = conn.execute("select CURRVAL('contact_id_seq')") {|rows| rows.each {|row| break row.to_h['currval']}}
puts "Last sequence number: #{a.inspect}"
puts "Returning rowset: #{rowset.inspect}"
puts

puts "Select after insert"
conn.execute "select * from contact" do |rows|
  rows.each do |row|
    row.to_h.each_value {|val| print "#{val} "}
    puts
  end
end
puts

puts "Executing delete"
conn.execute "delete from contact where lst_name='Ульянов' and fst_name='Кирилл' and mdl_name='Евгеньевич'"
puts

puts "select after delete"
conn.execute "select * from contact" do |rows|
  rows.each do |row|
    row.to_h.each_value {|val| print "#{val} "}
    puts
  end
end
