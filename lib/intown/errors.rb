module Intown
  IntownError = Class.new(StandardError)
  InvalidRequestError = Class.new(IntownError)
  InternalServerError = Class.new(IntownError)
end
