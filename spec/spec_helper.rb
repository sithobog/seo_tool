ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'
require 'capybara'

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems


require_relative "../lib/seo/application.rb"

Capybara.app = Seo::Application.new


RSpec.configure do |config|
  include Rack::Test::Methods
  include Capybara::DSL

  def app
    Seo::Application.new
  end
end
