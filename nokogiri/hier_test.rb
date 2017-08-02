require "nokogiri"
require "set"

module NamedNodeSet
  def self.extended base
    base.children.each do |node|
      method_name = node.name.downcase.to_sym
      while base.respond_to? method_name
        method_name = "_#{method_name.to_s}".to_sym
      end
      base.instance_eval do
        define_singleton_method method_name, proc { node }
      end
      node.extend NamedNodeSet
    end
  end
end

exit 42 unless ARGV[0]

if File.exists? ARGV[0]
  file = File.new ARGV[0]
else
  exit 43
end

doc = Nokogiri::XML file.read
doc.extend NamedNodeSet