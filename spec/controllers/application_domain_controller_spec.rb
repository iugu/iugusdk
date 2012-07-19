require 'spec_helper'

class StubApplicationDomainController < Iugu::ApplicationDomainController
  
  def index
    render :text => "true", :status => 200
  end

end

describe StubApplicationDomainController do

  def with_stub_routing
    with_routing do |map|
      map.draw do
        match '/stub/application/domain/index' => "stub_application_domain#index"
      end 
      yield
    end 
  end

  it 'should be_success' do
    with_stub_routing do
      get :index
    end
    response.should be_success
  end
  
end
