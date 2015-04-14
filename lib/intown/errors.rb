module Intown
  IntownError = Class.new(StandardError)
  InvalidRequestError = Class.new(IntownError)
  InvalidResponseError = Class.new(IntownError)
  InternalServerError = Class.new(IntownError)
  BadGatewayError = Class.new(IntownError)
end
