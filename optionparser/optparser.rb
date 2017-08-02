require "optionparser"

OptionParser.new do |opts|
  opts.banner = "usage hints"
  opts.on("-sARG","--string=ARG",String, "String arg") do |arg|
    puts "String: #{arg}"
  end
  opts.on("-b","--[no-]bool","Boolean arg") do |arg|
    puts "Boolean: #{arg}"
  end
  opts.on("-aARG","--arr=ARG",Array,"List arg") do |arg|
    puts "Array: #{arg}"
  end
end.parse!