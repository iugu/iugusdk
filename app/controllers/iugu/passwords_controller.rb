class Iugu::PasswordsController < Devise::PasswordsController
  after_filter :select_account, :only => :update
end
