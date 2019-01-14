module Yelp
  CONSUMER_KEY = "TMBwmXbGmCN0LyOTxVwmpg"
  CONSUMER_SECRET = "qUkIaJQ8NNfmlhzA-P00q5nd_Ek"
  TOKEN = "Hb-XGC6RZGqJStBPmHCbCRr2jNiNlbC-"
  TOKEN_SECRET = "b0CrUfsINlqQI3N9HqVBFseol_I"
  API_HOST = "api.yelp.com"

  class Connection
    require 'json'

    attr_reader :access_token

    def initialize
      # @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, { site: "http://#{API_HOST}", proxy: "http://proxy.vscht.cz:3128/" })
      @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, { site: "http://#{API_HOST}" })
      @access_token = OAuth::AccessToken.new(@consumer, TOKEN, TOKEN_SECRET)
    end

    def find_by_id(business_id)
      response = @access_token.get("/v2/business/#{business_id}").body
      JSON.parse(response).symbolize_keys
    end
  end
end
