require_relative '../lib/seo/storage/file_storage'

RSpec.describe Seo::FileStorage do
  it "grabs file" do
    report_list = Seo::FileStorage.new.all_reports('./spec/tmp/')
    report_list.each do |report|
      expect(report[:url].to_s).to eq("test-for-file.com")
      expect(report[:time].to_s).to eq("11 February 2220 13:53")
      expect(report[:path].to_s).to eq("test-for-file.com-7892769207.html")
    end
  end
end
