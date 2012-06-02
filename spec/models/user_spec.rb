require 'spec_helper'

describe User do

  subject{ Fabricate(:user) }

  it { should have_many(:account_users) }
  it { should have_many(:accounts).through(:account_users) }

end
