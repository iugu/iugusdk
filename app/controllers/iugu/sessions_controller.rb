class Iugu::SessionsController < Devise::SessionsController
  after_filter :select_account, :only => :create 

  layout IuguSDK.alternative_layout
end
