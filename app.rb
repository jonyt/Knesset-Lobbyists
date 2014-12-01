require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :development)
Dotenv.load if ENV['RACK_ENV'].downcase != 'production'

require_relative 'models/init'

class App < Sinatra::Base

	configure do
	  set :server,            %w(unicorn)
	  set :raise_errors,      development?
	  set :logging,           true
	end

  get '/' do
    @companies = Company.all.
      inject([]){|mem, donor| mem << {:value => donor.id, :label => donor.name}}.
      to_json

    erb :index
  end

  get '/company/:id' do
    company_id = params['id'].to_i
    @company = Company[company_id]    

    erb :company
  end
end

