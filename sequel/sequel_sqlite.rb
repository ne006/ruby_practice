#!/usr/bin/env ruby
require "sequel"
require "pry"

db = Sequel.connect("sqlite:/mnt/sdcard/bin/dblite.db")

binding.pry