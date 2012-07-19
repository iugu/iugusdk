class Iugu::ApplicationDomainController < ApplicationController

  before_filter :get_account_from_domain
  
  private

  def get_account_from_domain
    @account = Account.get_from_domain(params[:host]) if params[:host]
  end
  
end
