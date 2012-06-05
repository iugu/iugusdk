require 'spec_helper'

describe SocialAccount do
  it { should belong_to :user }
end
