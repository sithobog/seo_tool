require 'sinatra'
require 'seo/seo_parser'
require 'seo/report_list'

module Seo
  class Application < ::Sinatra::Application
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

  end
end
