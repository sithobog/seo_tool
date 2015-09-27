require_relative 'abstract_storage'
require_relative '../configuration.rb'
require 'pg'

module Seo
	class PostgresStorage < AbstractStorage

    def initialize
      @db_name = Seo.configuration.db_name
      check_database(@db_name)
      #conn = PG.connect(host: 'localhost', port: '5432',dbname: 'seo_test12345', user: 'tester', password: 'test_password')
      create_tables
    end

    def create_tables
      #create reports table
      client.exec("CREATE TABLE IF NOT EXISTS reports(
        id SERIAL PRIMARY KEY,
        url TEXT,
        created_at TIMESTAMP,
        remote_ip INET);")
      #create links table
      client.exec("CREATE TABLE IF NOT EXISTS links(
        id SERIAL PRIMARY KEY,
        name TEXT,
        href TEXT,
        target VARCHAR(15),
        rel VARCHAR(15),
        report_id INTEGER REFERENCES reports);")
      #create headers table
      client.exec("CREATE TABLE IF NOT EXISTS headers(
        id SERIAL PRIMARY KEY,
        name VARCHAR(255),
        value TEXT,
        report_id INTEGER REFERENCES reports);")
    end

    def client
      #conn = PG::Connection.open(:dbname => 'test')
      @client ||= PG::Connection.open(:dbname => @db_name)
    end

		def all_reports()
      report_list = []
      client.exec("SELECT * from reports") do |result|
        result.each do |row|
          report_list << { url: row['url'],
                        created_at: row['created_at'],
                        id: row['id']
                      }
        end
      end
      report_list
		end



		def add_report(report)
      _url = report.prepare_site_url(report.site_url)
      report.grab_ip(report.site_url) if report.ip.nil?
      client.exec("INSERT INTO reports(url,created_at,remote_ip) VALUES(
        '#{_url}',
        '#{Time.now}',
        '#{report.ip}');")
      _report_id = last_record.values.shift[0]
      add_links(report, _report_id)
      add_headers(report,_report_id)
		end

    def add_links(report,report_id)
      query = ''
      #prepare string for insert 
      report.links.each do |link|
        query +="('#{escape_apostrophe(link.text)}',
          '#{escape_apostrophe(link['href'])}',
          '#{escape_apostrophe(link['target'])}',
          '#{escape_apostrophe(link['rel'])}',
          '#{(report_id)}'),"
      end
      #remove comma in the end
      query.chop!
      client.exec("INSERT INTO links(name,href,target,rel,report_id) VALUES #{query};")
    end

    def add_headers(report,report_id)
      query = ''
      #prepare string for insert 
      report.headers.each do |k,v|
        query += "('#{escape_apostrophe(k)}',
          '#{escape_apostrophe(v)}',
          '#{(report_id)}'),"
      end
      #remove comma in the end
      query.chop!
      client.exec("INSERT INTO headers(name,value,report_id) VALUES #{query};")
    end

    def last_record(column='id',table='reports')
      client.exec("SELECT #{column} FROM #{table}
        ORDER BY created_at DESC
        LIMIT 1;")
    end

    def escape_apostrophe(string)
      old_string = string
      string = " " if string.nil?
      if string.include? '\''
        string.gsub!('\'','\'\'')
      else
        old_string
      end
    end

    def check_database(db_name)
      conn = PG.connect(dbname: 'postgres')
      #if database exists tuples is equal 1 else tuples is equal 0
      check = conn.exec("SELECT 1 FROM pg_database WHERE datname = '#{db_name}'").ntuples
      conn.exec("CREATE DATABASE #{db_name}") if check == 0
    end

    def drop_tables
      client.exec("DROP TABLE reports,links,headers;")
      create_tables
    end

		def find_report(guid)
      #grab report
      report = []
      client.exec("SELECT * from reports where id=#{guid}") do |result|
        result.each do |row|
          report << { url: row['url'],
                        created_at: row['created_at'],
                        remote_ip: row['remote_ip']
                      }
        end
      end
      #grab links
      links = []
      client.exec("SELECT * from links where report_id=#{guid}") do |result|
        result.each do |row|
          links << { name: row['name'],
                        href: row['href'],
                        target: row['target'],
                        rel: row['rel']
                      }
        end
      end
      #grab headers
      headers= []
      client.exec("SELECT * from headers where report_id=#{guid}") do |result|
        result.each do |row|
          headers << { name: row['name'],
                        value: row['value']
                      }
        end
      end
      return a = [report, links, headers]
		end

	end
end
