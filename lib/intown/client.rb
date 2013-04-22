require 'httparty'
require 'json'
require 'hashie'

module Intown
  class Client
    include HTTParty
    API_VERSION = 2.0
    base_uri "https://api.bandsintown.com"

    class << self

      def options
        {
          :query => {
             :app_id => Intown.configuration.app_id, :api_version => API_VERSION, :format => "json"
          }
        }
      end

      def process_response(response)
        case response.code
        when 500 then raise Intown::InvalidRequestError, response.body
        when 404 then process_not_found(response)
        when 406 then process_not_acceptable(response)
        else
          json_response = JSON.parse(response.body)

          if json_response.is_a? Hash
            Hashie::Mash.new(json_response)
          elsif json_response.is_a? Array
            json_response.map {|e| Hashie::Mash.new(e)}
          else
            json_response
          end
        end
      end
      
      def process_not_acceptable(response)
        raise Intown::InvalidRequestError, "Bandsintown rejected your request.  Please check your input parameters."
      end

      def process_not_found(response)
        json = JSON.parse(response.body)
        if errors = json['errors']
          raise Intown::InvalidRequestError, "app_id is required for this request" if errors.any? {|e| e =~ /app_id param is required/}
        end
        nil
      end

      def artist_identifier(params)
        return musicbrainz_identifier(params[:mbid]) if params[:mbid]
        return facebook_identifier(params[:fbid]) if params[:fbid]
        return encode_name(params[:name]) if params[:name]
        raise ArgumentError, "params must contain one of mbid, fbid, or name"
      end
      
      def encode_name(name)
        # periods & slashes cause the API to blow up
        # must double-encode the slash
        URI.encode(name).gsub(/\./, "%2E").gsub(/\//, "%252F")
      end

      def musicbrainz_identifier(mbid)
        "mbid_#{mbid}"
      end

      def facebook_identifier(fbid)
        "fbid_#{fbid}"
      end
    end
  end
end
