class Iugu::PasswordsController < Devise::PasswordsController
  after_filter :select_account, :only => :update

  layout IuguSDK.alternative_layout
end
