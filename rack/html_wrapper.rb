#!/usr/bin/env ruby
require 'nokogiri'

class HTMLWrapper

  def initialize app
    @app = app
  end

  def call env
    request = Rack::Request.new env
    response = Rack::Response.new

    builder = Nokogiri::HTML::Builder.new do |doc|
      doc.html {
        doc.head {
          doc.title { doc.text "Rack@#{request.host_with_port}" }
          doc.style(type:"text/css") {
            doc.text ".elem {\n"
            doc.text "width: 800px;\n"
            doc.text "margin-left: auto;\n"
            doc.text "margin-right: auto;\n"
            doc.text "}\n"
          }
        }
        doc.body {
          @app.call(env).at(2).each do |response_part|
            doc.div(class: "elem") {
              response_part.each_line do |line|
                doc.p(class: "line") {doc.text line}
              end
            }
          end
        }
      }
    end

    response.write builder.to_html
    response.finish
  end

end
