#!/usr/bin/env ruby
require 'sequel'

DB = Sequel.connect("postgres://postgres:postgres@localhost/ruby_practice")
contact = DB[:contact]

print_row = Proc.new do |row|
  row.each_value do |col|
    print "#{col} "
  end
  puts
end

puts "Initial select"
contact.each &print_row

puts "Conditional select with column ordering/selection"
contact.select(:id, :lst_name, :fst_name, :mdl_name).where(:id => 2).each &print_row

puts "Insert"
new_id = contact.insert(lst_name:"Новиков",fst_name:"Николай",mdl_name:"Степанович")
puts "new id = #{new_id}"
puts "Select after insert"
contact.each &print_row

puts "Delete"
contact.where(:id=> new_id).delete
puts "Select after delete"
contact.each &print_row
