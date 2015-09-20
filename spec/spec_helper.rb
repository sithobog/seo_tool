ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'
require 'webmock/rspec'

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems


require_relative "../lib/seo/application.rb"


RSpec.configure do |config|
  include Rack::Test::Methods
  
  def app
    Seo::Application.new
  end

  config.before(:each) do
    WebMock.disable_net_connect!(:allow => "example.wrong")
    stub_request(:any, "http://test_url.net").to_return(:body => "hola wola motorola",
                 :status => 200, :headers => { 'Content-Length' => "18", 'x-test' => "Yes it works!"})
  end

  config.before(:all) do
    FileUtils.mkdir_p("./spec/tmp/") unless File.directory?("./spec/tmp/")
    # Creates empty dir for the ReportList test
    FileUtils.mkdir_p("./spec/tmp/tmp") unless File.directory?("./spec/tmp/tmp")
    # File for ReportList
    File.open("./spec/tmp/test-for-file.com-7892769207.html", 'w')
  end

    config.after(:all) do
    # Remove temporary files
    FileUtils.rm_rf(Dir["./public/reports/test_url*"])
    FileUtils.rm_rf(Dir["./spec/tmp/"])
    WebMock.allow_net_connect!
  end


end
