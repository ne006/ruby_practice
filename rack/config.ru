#\ -s webrick

require_relative 'app.rb'
require_relative 'html_wrapper.rb'

use Rack::Reloader
use HTMLWrapper
run App.new
