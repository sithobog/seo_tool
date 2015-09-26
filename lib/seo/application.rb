require 'sinatra/base'
require 'seo/seo_parser'
require 'seo/storage/file_storage'
require 'seo/storage/database_storage'
require_relative '../seo.rb'

module Seo
  class Application < Sinatra::Base

    before do
    FileUtils.mkdir_p("./public/reports/") unless File
      .directory?("./public/reports/")
    end

    # Configuration
    set :public_folder, -> { Seo.root_path.join('public').to_s }
    set :views, -> { Seo.root_path.join('views').to_s }

    # Middleware
    #use Rack::CommonLogger
    use Rack::Reloader

    get '/' do
      @report_list = DatabaseStorage.new.all_reports
      #@report_list = FileStorage.new.all_reports
      #storage = DatabaseStorage.new
      slim :index
    end

    post '/reports/' do
      site_url = params[:site_url]
      report = SeoParser.new(site_url)
      #FileStorage.new.add_report(report)
      DatabaseStorage.new.add_report(report)

      redirect "/"
    end

    get '/report/:guid' do
      array_of_array = DatabaseStorage.new.find_report(params['guid'])
      @report = array_of_array[0]
      @links = array_of_array[1]
      @headers = array_of_array[2]
      slim :report
    end

    get '/drop_tables' do
      DatabaseStorage.new.drop_tables
      redirect "/"
    end

    not_found do
      status 404
      slim :not_found
    end


    error do
      slim :error
    end
    
  end
end
