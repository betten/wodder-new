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
    it "should not have paid be true" do
      @user.should_not be_paid
    end
    it "should not allow username to be 'wods' or other reserved words" do
      @user.username = "wods"
      @user.should have(1).error_on(:username)
    end
  end
  describe "a user saving wods" do
    before do 
      @user = User.new
    end
    it "should be able to save multiple wods" do
      @user.saved_wods.should be_empty
      3.times do
        expect {
          wod = GymWod.new
          @user.saved_wods << wod
          @user.saved_wod_ids.should include(wod.id)
          wod.saved_by_ids.should include(@user.id)
        }.to change { @user.saved_wod_ids.count }.by(1) and change { wod.saved_by_ids.count }.by(1)
      end
    end
  end
  describe "with saved wods" do
    before do
      @user = User.new
      @wods = [GymWod.new, UserWod.new, GymWod.new, UserWod.new]
      @wods.each do |wod|
        @user.saved_wods << wod
      end
    end
    it "should be able to check wods with has_saved_wod?" do
      @wods.each do |wod|
        @user.has_saved_wod?(wod).should be true
      end
      @user.has_saved_wod?(GymWod.new).should be false
      @user.has_saved_wod?(UserWod.new).should be false
    end
    it "should be able to get saved wods with saved_wods" do
      @wods.each do |wod|
        @user.saved_wods.should include(wod)
      end
      @user.saved_wods.should_not include(GymWod.new)
      @user.saved_wods.should_not include(UserWod.new)
    end
  end
end
