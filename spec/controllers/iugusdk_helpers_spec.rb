require 'spec_helper'

class StubIuguHelpersController < SessionsController
  def render_result_of( condition )
    if condition
      render :text => "true", :status => 200
    else
      render :text => "false", :status => 404
    end
  end

  def test_current_user_account
    @current_user_account = current_user_account
    render_result_of signed_in?
  end

  def check_is_active
    params[:id] = 5
    render_result_of is_active?("stub_iugu_helpers","test_is_active") && is_active?("stub_iugu_helpers") && is_active?("stub_iugu_helpers", "test_is_active", 5)
  end

  def test_is_active
    check_is_active()
  end

  def test_is_inactive
    check_is_active()
  end

  def test_body_classes
    css_controller, css_action, css_page = body_classes
    render_result_of( css_controller == controller_name && css_action == action_name && css_page == ('page-' + controller_name + '-' + action_name))
  end
end

describe StubIuguHelpersController do

  def with_stub_routing
    with_routing do |map|
      map.draw do
        match '/stub/iugu/helpers/index' => "stub_iugu_helpers#test_current_user_account"
        match '/stub/iugu/helpers/test_is_active' => "stub_iugu_helpers#test_is_active"
        match '/stub/iugu/helpers/test_is_inactive' => "stub_iugu_helpers#test_is_inactive"
        match '/stub/iugu/helpers/test_body_classes' => "stub_iugu_helpers#test_body_classes"
      end
      yield
    end
  end

  context "with a logged user" do

    login_as_user

    it "should be signed_in" do
      with_stub_routing do
        get :test_current_user_account
        response.should be_success
      end
    end
  end

  context "with no logged user" do
    it "should not have a user account" do
      with_stub_routing do
        get :test_current_user_account
        response.should_not be_success
      end
    end
  end

  context "helpers" do
    it "should return true for is_active at test_is_active" do
      with_stub_routing do
        get :test_is_active
        response.should be_success
      end
    end

    it "should return false for is_active at test_is_inactive" do
      with_stub_routing do
        get :test_is_inactive
        response.should_not be_success
      end
    end

    it "should return true for body_classes check" do
      with_stub_routing do
        get :test_body_classes
        response.should be_success
      end
    end
  end

end
