class Iugu::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def passthru
    render :status => 404, :text => "Not found. Authentication passthru."
  end
end
