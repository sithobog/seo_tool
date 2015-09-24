require 'sinatra/base'
require 'seo/seo_parser'
require 'seo/storage/file_storage'
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
      @report_list = FileStorage.new.all_reports
      slim :index
    end

    post '/reports/' do
      site_url = params[:site_url]
      report = SeoParser.new(site_url)
      FileStorage.new.add_report(report)

      redirect "/"
    end

    get '/report/:guid' do
      FileStorage.new.find_report(params['guid'])
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
