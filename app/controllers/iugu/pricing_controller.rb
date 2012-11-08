class Iugu::PricingController < ApplicationController

  def index
    if IuguSDK::iws_api_key
      @plans = Iugu::Api::Plan.all
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
end
