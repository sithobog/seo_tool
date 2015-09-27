require 'sequel'
require_relative '../configuration.rb'

module Seo
	class SequelStorage

		DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost',
												:database => 'sequel_test', :user => 'tester', :password => 'test_password')

		def initialize
			check_database('sequel_test')
			create_tables?
		end
		

		def all_reports
			reports = DB.from(:reports).all
		end

		def find_report(guid)
			report = DB.from(:reports).where(:id => guid).all
			links = DB.from(:links).where(:report_id => guid).all
			headers = DB.from(:headers).where(:report_id => guid).all
			return a = [report, links, headers]
		end

		def add_report(report)
			reports = DB.from(:reports)
			_url = report.prepare_site_url(report.site_url)
			report.grab_ip(report.site_url) if report.ip.nil?
			reports.insert(:url => _url,
      							:created_at => Time.now,
      							:remote_ip => report.ip)
			_report_id = reports.order(:id).last[:id]
      add_links(report,_report_id)
      add_headers(report,_report_id)
		end


		def add_links(report,report_id)
			DB.transaction do
				report.links.each do |link|
				  DB[:links].insert(:name => link.text,
	      							:href => link['href'],
	      							:target => link['target'],
	      							:rel => link['rel'],
	      							:report_id => report_id)
				end
			end
		end

		def add_headers(report,report_id)
			DB.transaction do
				report.headers.each do |k,v|
				  DB[:headers].insert(:name => k,
	      							:value => v,
	      							:report_id => report_id)
				end
			end
		end

	  def check_database(db_name)
      conn = PG.connect(dbname: 'postgres')
      #if database exists tuples is equal 1 else tuples is equal 0
      check = conn.exec("SELECT 1 FROM pg_database WHERE datname = '#{db_name}'").ntuples
      conn.exec("CREATE DATABASE #{db_name}") if check == 0
    end

    def drop_tables
    	DB.drop_table?(:reports, :links, :headers, :cascade => true)
    	create_tables?
    end

    # creates tables if nesessary
		def create_tables?

			DB.create_table? :reports do
			  primary_key :id
			  String :url
			  DateTime :created_at
			  Inet :remote_ip
			end

			DB.create_table? :headers do
			  primary_key :id
			  String :name
			  String :value
			  Float :price
			  foreign_key :report_id, :reports
			end

			DB.create_table? :links do
			  primary_key :id
			  String :name
			  String :href
			  String :target
			  String :rel
			  foreign_key :report_id, :reports
			end

		end

	end
end
