module Intown
  class Artist < Client
    class << self
      def fetch(params)
        identifier = artist_identifier(params)
        response = get("/artists/#{identifier}", options)
        process_response(response)
      end
    end
  end
end
