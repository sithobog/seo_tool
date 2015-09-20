require_relative '../lib/seo/report_list'

RSpec.describe Seo::ReportList do
  it "grabs file" do
    report_list = Seo::ReportList.new('./spec/tmp/').grab_files
    report_list.each do |report|
      expect(report[:url].to_s).to eq("test-for-file.com")
      expect(report[:time].to_s).to eq("11 February 2220 13:53")
      expect(report[:path].to_s).to eq("test-for-file.com-7892769207.html")
    end
  end
end
