module Tourbus
  class Artist < Client
    class << self
      def fetch(params)
        identifier = artist_identifier(params)
        response = get("/artists/#{URI.encode(identifier)}", options)

        case response.code
        when 500 then raise Tourbus::InvalidRequestError, response.body
        when 404 then process_not_found(response)
        else
          json_response = JSON.parse(response.body)
          Hashie::Mash.new(json_response)
        end
      end

    end
  end
end

