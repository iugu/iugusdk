require 'spec_helper'

describe Account do

  it { should have_many(:account_users) }
  it { should have_many(:users).through(:account_users) }

  it "should return true for a valid user of account" do
    @user = Fabricate(:user, :email => "me@me.com")
    @account = Fabricate(:account)
    @account.account_users << Fabricate(:account_user, :user => @user)
    @account.valid_user_for_account?( @user ).should be_true
  end

  context "destruction_job method" do
    before(:each) do
      @account = Fabricate(:account)
    end

    it 'should return a job' do
      @account.destroy
      @account.destruction_job.class.should == Delayed::Backend::ActiveRecord::Job 
    end
    
    it 'should return null if account has no destruction job' do
      @account.destruction_job.should be_nil
    end
  
  end

  context "destrying? method" do
    before(:each) do
      @account = Fabricate(:account)
    end

    it 'should return true if account has a destruction job' do
      @account.destroy
      @account.destroying?.should be_true
    end

    it 'should return false if account doesnt have a destruction job' do
      @account.destroying?.should be_false
    end
  end

  context "cancel_destruction" do
    before(:each) do
      @account = Fabricate(:account)
    end

    it 'should cancel account destruction' do
      @account.destroy
      @account.cancel_destruction
      @account.destroying?.should be_false
    end
    
    it 'should return a job' do
      @account.destroy
      @account.cancel_destruction.class.should == Delayed::Backend::ActiveRecord::Job
    end

    it 'should return nil if doesnt have a destruction job' do
      @account.cancel_destruction.should be_nil
    end

    it 'should return nil if destruction job is already locked' do
      @account.destroy
      @job = @account.destruction_job
      @job.locked_at = Time.now
      @job.save
      @account.cancel_destruction.should be_nil
    end
  
  end

end
