$stdout.sync = true

unless $LOAD_PATH.include? "."
  $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
end

require 'app'
 
use Rack::ShowExceptions
 
run App.new

