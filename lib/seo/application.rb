require 'sinatra/base'
require 'seo/seo_parser'
require 'seo/report_list'
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
      @report_list = ReportList.new('./public/reports/').grab_files
      slim :index
    end

    post '/reports/' do
      site_url = params[:site_url]
      parser = SeoParser.new(site_url)
      parser.create_file(parser.site_url)
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
