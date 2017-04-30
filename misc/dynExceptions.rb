class StuffMatcher
  def self.=== other
    other.message =~ /.*stuff.*/
  end
end

begin
  raise StandardError, "stuff happened"
rescue StuffMatcher => e
  puts "Rescued a #{e.class}: #{e.message}"
end