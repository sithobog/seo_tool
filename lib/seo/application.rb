require 'sinatra'
require 'seo/seo_parser'

module Seo
  class Application < ::Sinatra::Application
    # Configuration
    set :public_folder, -> { Seo.root_path.join('public').to_s }
    set :views, -> { Seo.root_path.join('views').to_s }

    # Middleware
    #use Rack::CommonLogger
    use Rack::Reloader

    get '/' do
      slim :index
    end

    post '/reports/' do
      site_url = params[:site_url]
      parser = SeoParser.new(site_url)

      parser.create_file(parser.site_url, parser.headers, parser.links)

      redirect "/"
    end

  end
end