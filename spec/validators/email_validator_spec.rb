require 'spec_helper'

describe EmailValidator do
  before(:each) do
    class User < ActiveRecord::Base
      validates :email, :email => true
    end
  end

  it 'should allow valid emails' do
    Fabricate(:user) do
      email "good@email.com"
    end.should be_valid
  end

  it 'should not allow invalid emails' do
    Fabricate.build(:user) do
      email "notanemail"
    end.should_not be_valid
  end
end
