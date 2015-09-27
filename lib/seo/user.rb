require 'sequel'
require 'bcrypt'
module Seo

  class User
  	attr_accessor :id
		DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost',
												:database => 'warden_test', :user => 'tester', :password => 'test_password')

		def initialize(id, username, password, ip)
			@id = id
			@username = username
			@password = password
			@ip = ip
			create_table
		end

		def authenticate(attempted_password)
		  if @password == attempted_password
		    true
		  else
		    false
		  end
		end

		def self.get(id)
			DB.from(:users).where(:id => id).all
		end

		def self.get_by_name(name)
			DB.from(:users).where(:username => name).all
		end

		def add_user(name,password)
			users = DB.from(:users)
			users.insert.(:username => name, :password => password)
		end

    def create_table
			DB.create_table? :users do
			  primary_key :id
			  String :username
			  String :password
			  Inet :user_ip
			end
    end

	end
end
