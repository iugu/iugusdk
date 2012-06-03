#encoding: utf-8
class DashboardController < ApplicationController

  def index
    render 'dashboard/splash' unless current_user
  end

end
