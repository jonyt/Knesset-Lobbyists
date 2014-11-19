require 'sinatra'

class App < Sinatra::Base

	configure do
	  set :server,            %w(unicorn)
	  set :raise_errors,      development?
	  set :logging,           true
	end
end

