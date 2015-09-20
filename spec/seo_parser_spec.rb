require_relative '../lib/seo/seo_parser'

RSpec.describe Seo::SeoParser do
  it "parses page" do
    uri = URI("http://test_url.net")
    parser = Seo::SeoParser.new(uri.to_s)
    parser.ip = "123.23.52.55"
    parser.create_file(parser.site_url)
    expect(parser.headers).to include("x-test" => ["Yes it works!"])
  end
end
