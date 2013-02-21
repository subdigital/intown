require 'httparty'
require 'json'
require 'hashie'

module Tourbus
  class Client
    include HTTParty
    API_VERSION = 2.0
    base_uri "https://api.bandsintown.com"

    class << self

      def options
        {
          :query => {
             :app_id => Tourbus.configuration.app_id, :api_version => API_VERSION 
          }
        }
      end

      def process_not_found(response)
        json = JSON.parse(response.body)
        if errors = json['errors']
          raise Tourbus::InvalidRequestError, "app_id is required for this request" if errors.any? {|e| e =~ /app_id param is required/}
        end
        nil
      end
    end
  end
end
