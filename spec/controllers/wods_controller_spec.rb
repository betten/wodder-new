require 'spec_helper'

describe WodsController do
  before do
    @user = User.new
    User.stub!(:find).with(@user.id).and_return(@user)
  end

  def user_is_signed_in
    session[:current_user_id] = @user.id
  end
  def user_is_paid
    @user.stub!(:is_paid?).and_return(true)
  end
  def user_is_not_paid
    @user.stub!(:is_paid?).and_return(false)
  end

  describe "saved wods" do
    it "should not allow not signed in users access to saved wods" do
      get :saved
      response.should redirect_to signup_users_path
    end
    it "should not allow not paid users access to saved wods" do
      user_is_signed_in
      user_is_not_paid
      get :saved
      response.should redirect_to donate_path
    end
  end

  describe "saving wods" do
    before do
      @wod = GymWod.new
    end
    describe "permissions" do
      it "should not allow not signed in users to save wods" do
        get :save, :id => @wod.id
        response.should redirect_to signup_users_path
      end
      it "should not allow not paid users access to save wods" do
        user_is_not_paid
        user_is_signed_in
        get :save, :id => @wod.id
        response.should redirect_to donate_path
      end
    end
    describe "updating user" do
      before do
        user_is_paid
        user_is_signed_in
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

  describe "unsaving wods" do
    describe "permissions" do
      before do
        @wod = GymWod.new
      end
      it "should not allow a not signed in user to unsave wods" do # does this even make sense? how/why would a non-signed-in user be trying to unsave anything?
        get :unsave, :id => @wod.id
        response.should redirect_to signup_users_path
      end
      it "should not allow a not paid user to unsave wods" do
        user_is_not_paid
        user_is_signed_in
        get :unsave, :id => @wod.id
        response.should redirect_to donate_path
      end
    end
    describe "updating user" do
      before do
        user_is_paid
        user_is_signed_in
        @wod = GymWod.new
        request.env["HTTP_REFERER"] = "/wods"
      end
      it "should remove wod from user.saved_wods and remove user id from wod and save both" do
        @user.saved_wods << @wod
        Wod.should_receive(:find).with(@wod.id).and_return(@wod)
        @user.should_receive(:save)
        @wod.should_receive(:save)
        expect {
          get :unsave, :id => @wod.id
        }.to change { @user.saved_wods.count }.by(-1) and change { @user.saved_wod_ids.count }.by(-1) and change { @wod.saved_by_ids.count }.by(-1)
        @user.saved_wods.should_not include(@wod)
        @user.saved_wod_ids.should_not include(@wod.id)
        @wod.saved_by_ids.should_not include(@user.id)
      end  
      it "should redirect to :back on call to unsave" do
        Wod.should_receive(:find).with(@wod.id).and_return(@wod)
        get :unsave, :id => @wod.id
        response.should redirect_to request.env["HTTP_REFERER"]
      end 
    end
  end
end
