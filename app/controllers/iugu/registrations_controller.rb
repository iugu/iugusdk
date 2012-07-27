class Iugu::RegistrationsController < Devise::RegistrationsController
  after_filter :select_account, :only => [:create,:update]
end

