module Intown
  IntownError = Class.new(StandardError)
  InvalidRequestError = Class.new(IntownError)
  InternalServerError = Class.new(IntownError)
  BadGatewayError = Class.new(IntownError)
end
