require File.dirname(__FILE__) + '/spec_helper'

RSpec.describe Seo::Application do
  describe "Index" do
    it "get index" do
      get '/'
      expect(last_response.body).to include "Put url here"
      expect(last_response.status).to eq 200
    end
  end

  describe "get undefined path" do
    it "shows error" do
      get '/something_wrong'
      expect(last_response.body).to include "This page doesn't exist"
      expect(last_response.status).to eq 404
    end
  end
end
