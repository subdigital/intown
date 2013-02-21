module Tourbus
  class Event < Client
    class << self
      def list(params)
        identifier = artist_identifier(params)
        url = "/artists/#{URI.encode(identifier)}/events"
        response = get(url, options)
        process_response(response)
      end
    end
  end
end
