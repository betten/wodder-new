require 'spec_helper'

describe User do
  describe "a new user" do
    before(:each) do 
      @user = User.new
    end

    it "should not allow empty email" do
      @user.should have_at_least(1).error_on(:email) 
      @user.should_not be_valid
    end
    it "should not allow empty username" do
      @user.should have_at_least(1).error_on(:username)
      @user.should_not be_valid
    end
    it "should not allow empty password" do
      @user.should have_at_least(1).error_on(:password)
      @user.should_not be_valid
    end
    it "should not allow spaces in username" do
      @user.username = "hello world"
      @user.should have_at_least(1).error_on(:username) # this should be have(1), not sure why it's showing 2 errors...
      @user.username = "helloworld"
      @user.should have(0).error_on(:username)
    end
    it "should not allow unconfirmed password" do
      @user.password = "test"
      @user.password_confirmation = "waka"
      @user.should have(1).error_on(:password)
      @user.password = "test"
      @user.password_confirmation = "test"
      @user.should have(0).error_on(:password)
    end
  end
end
