require 'sinatra/base'
require 'seo/seo_parser'
require 'seo/storage/storage'
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
      @report_list = Storage.all_reports
      slim :index
    end

    post '/reports/' do
      site_url = params[:site_url]
      report = SeoParser.new(site_url)
      Storage.add_report(report)

      redirect "/"
    end

    get '/report/:guid' do
      array_of_array = Storage.find_report(params['guid'])
      @report = array_of_array[0]
      @links = array_of_array[1]
      @headers = array_of_array[2]
      slim :report
    end

    get '/drop_tables' do
      Storage.drop_tables
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
