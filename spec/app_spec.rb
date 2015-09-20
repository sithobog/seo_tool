require File.dirname(__FILE__) + '/spec_helper'
require 'fakeweb'
require 'capybara'

RSpec.describe Seo::Application do
	FakeWeb.register_uri(:get, "http://example.com/test1", :body => "Hello World!")
  describe "Index" do
    it "get index" do
      get '/'
      expect(last_response.body).to include "Put url here"
      expect(last_response.status).to eq 200
    end
  end

  describe "post report" do
  	it "create report" do
  		visit '/'
  		fill_in 'site_url', with: "https://fodojo.com"
  		click_on 'GO!'
  		expect(page).to have_content("fodojo.com")
  		within(".col-xs-8.col-xs-offset-2.well .row .row:nth-child(2)") do
        click_on 'View'
        expect(page).to have_content("https://fodojo.com")
        expect(page).to have_content("Response headers")
      end
  		_time = Time.now.to_i
  		File.delete(File.expand_path("public/reports/fodojo.com-#{_time}.html"))
  	end
	end

end
