module Intown
  class Event < Client
    class << self
      def list(params)
        identifier = artist_identifier(params)
        event_params = options.merge(date_options(params))
        url = "/artists/#{identifier}/events"
        response = get(url, event_params)
        process_response(response)
      end

      def date_options(params)
        return {:date => format_date(params[:date])} if params[:date]
        return {:date => "#{format_date(params[:from])},#{format_date(params[:to])}"} if params[:from] && params[:to]
        return {:date => "upcoming"} if params[:upcoming] == true
        return {:date => "all"} if params[:all] == true
        {}
      end

      def format_date(date)
        date.strftime("%Y-%m-%d")
      end
    end
  end
end
