require 'sinatra/base'
require 'sinatra/flash'
require 'seo/seo_parser'
require 'seo/storage/storage'
require 'seo/user'
require 'seo/warden'
require 'warden'
require 'pry-byebug'
require_relative '../seo.rb'

module Seo
  class Application < Sinatra::Base

    register Sinatra::Flash

    before do
    FileUtils.mkdir_p("./public/reports/") unless File
      .directory?("./public/reports/")
    end

    # Configuration
    set :public_folder, -> { Seo.root_path.join('public').to_s }
    set :views, -> { Seo.root_path.join('views').to_s }
    enable :sessions
    set :session_secret, "holawola"


    # Middleware
    #use Rack::CommonLogger
    use Rack::Reloader

    get '/' do
      @report_list = Storage.all_reports
      #@user = Seo::User.get_by_name('test')
      slim :index
    end

    post '/reports/' do
      site_url = params[:site_url]
      report = SeoParser.new(site_url)
      Storage.add_report(report)

      redirect "/"
    end

    helpers do
      def logged_in?
        env['warden'].authenticated?
      end
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

    #WARDEN
    get '/auth/login' do
      slim :login
    end

    post '/auth/login' do
      env['warden'].authenticate(:password)
      redirect '/'
    end

    get '/auth/logout' do
      env['warden'].raw_session.inspect
      env['warden'].logout
      flash[:success] = 'Successfully logged out'
      redirect '/'
    end

    post '/auth/unauthenticated' do
      session[:return_to] = env['warden.options'][:attempted_path]
      puts env['warden.options'][:attempted_path]
      flash[:error] = env['warden'].message || "You must log in"
      redirect '/auth/login'
    end
    
  end
end
