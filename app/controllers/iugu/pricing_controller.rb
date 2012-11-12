class Iugu::PricingController < ApplicationController
  before_filter :verify_api_key, :only => [ :index ]

  def index
    @plans = Iugu::Api::Plan.all
  end
  
end
