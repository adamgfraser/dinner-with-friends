class YelpClient

  def initialize
    @client = Yelp::Client.new
    @client.configure do |config|
      config.consumer_key = "iet5BTns6urx8_MPMSN9lg"
      config.consumer_secret = "LUwtv6MjjikYbt7BrHUxJV6oJ0E"
      config.token = "K3EIm60p2YqhX5H5DOyZoqfFJua3TGCS"
      config.token_secret = "oVvc-K6pQR31nGvujojMjty07hY"
    end
  end

  def search(location, params = {}, locale = {})
    @client.search(location, params, locale).businesses
  end

end