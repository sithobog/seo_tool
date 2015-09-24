require_relative 'abstract_storage'

module Seo
	class FileStorage < AbstractStorage
		PATH_CONST = './public/reports/'

		#def initialize(path)
		#end

		def all_reports(path=PATH_CONST)
			@files = Dir.entries(path).delete_if { |x| !(x =~ /html/) }
      if @files.any?
        _files = []
        @files.each do |file|
          #remove extenstion .html
          file = file.gsub(/.html/, '')
          #take timestamp of file
          _file_time = file[-10..-1]
          #fill array
          _files << {
            url: file.gsub(/-*[0-9]{10}/, ''),
            time: Time.at(_file_time.to_i).strftime("%e %B %Y %k:%M"),
            path: "#{file}.html"
          }
        end
        return _files.sort_by { |x| x[:url] }.reverse
      end
		end



		def add_report(report)
			report.grab_ip(report.site_url) if report.ip.nil?
      _time = Time.now.to_i
      report.initialize_time = Time.at(_time).strftime("%e %B %Y %k:%M")
      _body = Slim::Template.new(File.expand_path('report.slim', "views/"), {}).render(report)
      _ready_url = report.prepare_site_url(report.site_url)
      File.write(File.expand_path("#{_ready_url}-#{_time}.html", "public/reports"),_body)
		end

		def find_report(guid)
			File.read(File.expand_path("#{guid}","public/reports"))
		end

	end
end
