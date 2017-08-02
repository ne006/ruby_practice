#!/usr/bin/env ruby
require 'yaml'

p YAML.load(File.open "./data.yml").inspect
