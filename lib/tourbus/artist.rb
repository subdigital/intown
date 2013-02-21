module Tourbus
  class Artist < Client
    class << self
      def fetch(params)
        identifier = preferred_search_param(params)
        response = get("/artists/#{URI.encode(identifier)}", options)

        case response.code
        when 500 then raise Tourbus::InvalidRequestError, response.body
        when 404 then process_not_found(response)
        else
          json_response = JSON.parse(response.body)
          Hashie::Mash.new(json_response)
        end
      end

      def preferred_search_param(params)
        return musicbrainz_identifier(params[:mbid]) if params[:mbid]
        return facebook_identifier(params[:fbid]) if params[:fbid]
        return params[:name] if params[:name]
        raise ArgumentError, "params must contain one of mbid, fbid, or name"
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

