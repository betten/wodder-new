require 'spec_helper'

describe WodsController do
  before do
    @user = User.new
    User.stub!(:find).with(@user.id).and_return(@user)
  end
  describe "saved wods" do
    it "should not allow not signed in users access to saved wods" do
      get :saved
      response.should redirect_to signup_users_path
    end
    it "should not allow not paid users access to saved wods" do
      @user.stub!(:is_paid?).and_return(false)
      session[:current_user_id] = @user.id
      get :saved
      response.should redirect_to donate_path
    end
  end

  describe "saving wods" do
    describe "permissions" do
      it "should not allow not signed in users to save wods" do
        get :saved
        response.should redirect_to signup_users_path
      end
      it "should not allow not paid users access to save wods" do
        @user.stub!(:is_paid?).and_return(false)
        session[:current_user_id] = @user.id
        get :saved
        response.should redirect_to donate_path
      end
    end
    describe "updating user" do
      before do
        @user.stub!(:is_paid?).and_return(true)
        session[:current_user_id] = @user.id
        @wod = GymWod.new
        request.env["HTTP_REFERER"] = "/wods"
      end
      it "should find wod and update current_user.saved_wods on save" do
        Wod.should_receive(:find).and_return(@wod)
        @user.should_receive(:has_saved_wod?).with(@wod).and_return(false)
        @user.should_receive(:save).and_return(true)
        expect {
          get :save, :id => @wod.id
        }.to change { @user.saved_wod_ids.count }.by(1)
      end
      it "should redirect to :back on call to save" do
        Wod.should_receive(:find).and_return(@wod)
        @user.should_receive(:has_saved_wod?).and_return(true)
        get :save, :id => @wod.id
        response.should redirect_to request.env["HTTP_REFERER"]
      end
    end
  end
end
