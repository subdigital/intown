module Intown
  class Configuration
    attr_accessor :app_id
  end

  class << self
    def configure(&block)
      @configuration = Configuration.new
      yield @configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
