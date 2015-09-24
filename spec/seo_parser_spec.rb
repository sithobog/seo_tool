require_relative '../lib/seo/seo_parser'
require_relative '../lib/seo/storage/file_storage'

RSpec.describe Seo::SeoParser do
  it "parses page" do
    uri = URI("http://test_url.net")
    parser = Seo::SeoParser.new(uri.to_s)
    parser.ip = "123.23.52.55"
    Seo::FileStorage.new.add_report(parser)
    expect(parser.headers).to include("x-test" => ["Yes it works!"])
  end
end
