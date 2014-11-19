# See http://stackoverflow.com/questions/13002102/how-to-run-rack-based-application-not-rails-with-unicorn for how to run locally

worker_processes 3
timeout 15
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end
  
  require File.dirname(__FILE__) + '../models/init'
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  DB.disconnect if defined?(DB) && DB.is_a?(Sequel::Database)  
  
end