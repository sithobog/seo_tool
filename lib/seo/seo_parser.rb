require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'socket'

module Seo
  class SeoParser

    attr_reader :site_url, :links, :headers
    attr_accessor :ip, :initialize_time

    def initialize(site_url)
      @site_url = site_url
      @links = find_links(site_url)
      @headers = grab_url(site_url).headers.to_h
      @ip = nil
      @initialize_time = nil
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

    def grab_ip(url)
      @ip = IPSocket::getaddress(prepare_site_url(url))
    end

    def prepare_site_url(url)
        url.chop! if url[-1] == "/"
      if url.include?("https")
        url = url[8..url.length-1]
      else
        url = url[7..url.length-1]
      end
    end
    
  end
end
