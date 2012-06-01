class DummyController < ApplicationController
  
  def test
    # after_registration_callback() if respond_to? 'after_registration_callback'
    @app_name = Iugusdk.app_title
  end

end
