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

    def prepare_site_url(site_url)
        site_url.chop! if site_url[-1] == "/"
        site_url.gsub!('/', '_') if site_url.include?("/")
      if site_url.include?("https")
        site_url = site_url[8..site_url.length-1]
      else
        site_url = site_url[7..site_url.length-1]
      end
    end

    def create_file(site_url, headers, links)
      _body = Slim::Template.new(File.expand_path('report.slim', "views/"), {}).render(self)
      _ready_url = prepare_site_url(site_url)
      _time = time_format
      File.write(File.expand_path("#{_ready_url}_#{_time}.html", "public/reports"),_body)
      add_link_to_index(_ready_url, _time)
    end

    def add_link_to_index(url,time)
      open('views/index.slim', 'a') do |f|
        f << "\r a href='../reports/#{url}_#{time}.html' #{url}\n"
      end
    end

    def time_format
      _time = Time.now.to_s
      _time = _time.gsub(" ","_")
      _time = _time.gsub(":", "-")
      _time = _time[0..-7]
    end

  end
end