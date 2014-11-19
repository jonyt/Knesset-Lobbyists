require 'sequel'

class Lobbyist < Sequel::Model
  plugin :timestamps, :update_on_create => true  	 

  many_to_one :lobbying_company
end