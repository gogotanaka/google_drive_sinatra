require File.expand_path '../app.rb', __FILE__

require "rack-timeout"
use Rack::Timeout
Rack::Timeout.timeout = 100

run App
