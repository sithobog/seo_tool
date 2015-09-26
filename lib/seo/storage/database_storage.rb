require_relative 'abstract_storage'
require 'pg'

module Seo
	class DatabaseStorage < AbstractStorage

    def initialize
      #conn = PG.connect(dbname: 'postgres')
      #conn.exec("CREATE DATABASE seo_test")
      conn = PG.connect(host: 'localhost', port: '5432',dbname: 'seo_test', user: 'tester', password: 'test_password')
      #conn = PG.connect(dbname: 'postgres')
      create_tables
    end

    def create_tables
      #create reports table
      client.exec("CREATE TABLE IF NOT EXISTS reports(
        id SERIAL PRIMARY KEY,
        url TEXT,
        created_at TIMESTAMP,
        remote_ip TEXT);")
      #create links table
      client.exec("CREATE TABLE IF NOT EXISTS links(
        id SERIAL PRIMARY KEY,
        name TEXT,
        href TEXT,
        target VARCHAR(15),
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
      @client ||= PG::Connection.open(:dbname => 'seo_test')
    end

		def all_reports()
      report_list = []
      client.exec("SELECT * from reports") do |result|
        result.each do |row|
          report_list << { url: row['url'],
                        time: row['created_at'],
                        guid: row['id']
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
          '#{(report_id)}'),"
      end
      #remove comma in the end
      query.chop!
      client.exec("INSERT INTO links(name,href,target,report_id) VALUES #{query};")
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

		def find_report(guid)

		end

	end
end
