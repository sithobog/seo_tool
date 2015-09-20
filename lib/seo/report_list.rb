
module Seo
  class ReportList

		def initialize(path)
		  @files = Dir.entries(path).delete_if { |x| !(x =~ /html/) }
		end

    def grab_files()
      if @files.any?
        _files = []
        @files.each do |file|
          #remove extenstion .html
          file = file.gsub(/.html/, '')
          #take timestamp of file
          _file_time = file[-10..-1]
          #fill array
          _files << {
            url: file.gsub(/-*[0-9]{10}/, ''),#.gsub('_','/'),
            time: Time.at(_file_time.to_i).strftime("%e %B %Y %k:%M"),
            path: "#{file}.html"
          }
        end
        return _files.sort_by { |x| x[:url] }.reverse
      end
    end
  end
end
