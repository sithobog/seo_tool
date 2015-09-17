require 'httparty'
require 'nokogiri'
require 'open-uri'
#require 'slim'

module Seo
  class SeoParser

    attr_reader :site_url, :links, :headers

    def initialize(site_url)
      @site_url = site_url
      @links = find_links(@site_url)
      @headers = grab_url(@site_url).headers.to_h
    end

    def grab_url(site_url)
      response = HTTParty.get(site_url)
    end

    def find_links(site_url)
      links = []
      doc = Nokogiri::HTML(open(site_url))
      doc.search('a').each do |link|
        links << link
      end
      links
    end

    def create_file(site_url, headers, links)
      _body = Slim::Template.new(File.expand_path('report.slim', "views/"), {}).render(self)
      if site_url.include?("https")
        site_url = site_url[8..site_url.length-1]
      else
        site_url = site_url[7..site_url.length-1]
      end
      File.write(File.expand_path("#{site_url}_#{Time.now.to_s}.html", "public/reports"),_body)
    end

  end
end