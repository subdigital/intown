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
        when 500 then internal_server_error(response)
        when 502 then bad_gateway(response)
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
      rescue JSON::ParserError => e
        invalid_response_error(response)
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

      def internal_server_error(response)
        raise Intown::InternalServerError, "Bandsintown returned a 500 internal server error. Please retry this request later."
      end

      def bad_gateway(response)
        raise Intown::BadGatewayError, "Bandsintown returned a 502 proxy error. Please retry this request later."
      end

      def invalid_response_error(response)
        raise Intown::InvalidResponseError, "JSON parsing the Bandsintown response failed with: status_code: #{response.code}, body: #{response.body}"
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
        # question marks break the api as well
        sanitized_name = name.gsub(/\?/, "").strip
        URI.encode(sanitized_name).gsub(/\./, "%2E").gsub(/\//, "%252F")
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
