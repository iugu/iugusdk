require 'spec_helper'

describe ProfileController do

  it_should_require_login_for_actions :index

end
