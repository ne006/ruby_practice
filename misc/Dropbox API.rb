#!/usr/bin/env ruby
require 'net/http'
require 'json'

CLIENT_ID = "xk7vlq01dhbxngg"
CLIENT_SECRET = "42p6evwhpsj21dn"

token_uri = URI("https://api.dropboxapi.com/oauth2/token")

puts "Go to https://www.dropbox.com/oauth2/authorize?client_id=#{CLIENT_ID}&response_type=code"
puts "Paste it in here below:"
AUTH_CODE = gets.chop


Net::HTTP.start(
  token_uri.host,
  token_uri.port,
  :use_ssl => token_uri.scheme == 'https'
) do |http|

  request = Net::HTTP::Post.new token_uri
  request.set_form_data(
    "code" => AUTH_CODE,
    "grant_type" => "authorization_code",
    "client_id" => CLIENT_ID,
    "client_secret" => CLIENT_SECRET
  )

  response = http.request request
  response = JSON.parse(response.body)

  ACCESS_TOKEN = response["access_token"] if response["access_token"]

end

puts "Got the access token: #{ACCESS_TOKEN}"
