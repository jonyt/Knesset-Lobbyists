require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL']) unless defined? DB
raise "Unable to connect to #{ENV['DATABASE_URL']}" unless DB.test_connection

require_relative 'lobbyist'
require_relative 'company'
require_relative 'lobbying_company'