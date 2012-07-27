class Iugu::ConfirmationsController < Devise::ConfirmationsController
  after_filter :select_account, :only => :show
end
