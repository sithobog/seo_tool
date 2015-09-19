require 'httparty'
require 'nokogiri'
require 'open-uri'
#require 'slim'

module Seo
  class SeoParser

    attr_reader :site_url, :links, :headers

    def initialize(site_url)
      @site_url = site_url
      @links = find_links(site_url)
      @headers = grab_url(site_url).headers.to_h
    end

    def grab_url(url)
      response = HTTParty.get(url)
    end

    def find_links(url)
      links = []
      doc = Nokogiri::HTML(open(url))
      doc.search('a').each do |link|
        links << link
      end
      links
    end

    def prepare_site_url(url)
        url.chop! if url[-1] == "/"
        url.gsub!('/', '_') if url.include?("/")
      if url.include?("https")
        url = url[8..url.length-1]
      else
        url = url[7..url.length-1]
      end
    end

    def create_file(url)
      _body = Slim::Template.new(File.expand_path('report.slim', "views/"), {}).render(self)
      _ready_url = prepare_site_url(url)
      _time = Time.now.to_i
      File.write(File.expand_path("#{_ready_url}-#{_time}.html", "public/reports"),_body)
    end

  end
end
