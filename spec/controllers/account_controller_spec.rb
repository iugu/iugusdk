require 'spec_helper'

describe AccountController do

  it_should_require_login_for_actions :index

end
