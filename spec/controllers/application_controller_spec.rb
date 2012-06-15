require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      redirect_to '/'
    end
  end
  it 'should call set_locale' do
    controller.should_receive(:set_locale)
    get :index
  end
end
