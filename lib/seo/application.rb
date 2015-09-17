require 'sinatra'

module Seo
  class Application < ::Sinatra::Application
    # Configuration
    set :public_folder, lambda { Seo.root_path.join('public').to_s }
    set :views, lambda { Seo.root_path.join('views').to_s }

    # Middleware
    use Rack::CommonLogger
    use Rack::Reloader

    get '/' do
      slim :index
    end

  end
end