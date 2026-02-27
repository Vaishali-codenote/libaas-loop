require "net/http"
require "json"
require "cgi"

class CategoryImageFetcher
  CATEGORY_QUERY_MAP = {
    "lehenga" => "lehenga indian fashion",
    "saree" => "saree indian fashion",
    "anarkali" => "anarkali suit indian fashion",
    "sherwani" => "sherwani men indian fashion",
    "kurta" => "kurta indian fashion",
    "gown" => "gown women fashion"
  }.freeze

  UNSPLASH_QUERY_MAP = {
    "lehenga" => "bridal lehenga indian fashion",
    "saree" => "silk saree indian fashion",
    "anarkali" => "anarkali suit indian fashion",
    "sherwani" => "sherwani groom indian fashion",
    "kurta" => "kurta pajama indian fashion men",
    "gown" => "designer gown women fashion"
  }.freeze

  def initialize(category:, api_key: ENV["PEXELS_API_KEY"])
    @category = category.to_s.strip.downcase
    @api_key = api_key
  end

  def fetch
    pexels_image_url || unsplash_source_url || loremflickr_url
  end

  private

  attr_reader :category, :api_key

  def query
    CATEGORY_QUERY_MAP[category] || "ethnic fashion"
  end

  def pexels_image_url
    return nil if api_key.to_s.empty?

    uri = URI("https://api.pexels.com/v1/search?query=#{CGI.escape(query)}&per_page=20")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = api_key

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, read_timeout: 8, open_timeout: 5) do |http|
      http.request(request)
    end

    return nil unless response.code.to_i == 200

    body = JSON.parse(response.body)
    photos = body["photos"] || []
    chosen = photos.sample
    return nil unless chosen

    chosen.dig("src", "large2x") || chosen.dig("src", "large") || chosen.dig("src", "original")
  rescue StandardError
    nil
  end

  def loremflickr_url
    tag = category.empty? ? "fashion" : category
    "https://loremflickr.com/1000/1200/#{CGI.escape(tag)}"
  end

  def unsplash_source_url
    query = UNSPLASH_QUERY_MAP[category] || "ethnic fashion clothing"
    "https://source.unsplash.com/1200x1600/?#{CGI.escape(query)}"
  end
end
