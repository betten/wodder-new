require 'spec_helper'

describe UsersController do
  describe "donate" do
    before do
      @params = { :tx => "x", :st => "x", :amt => "x", :cc => "x", :sig => "x" }
      @user = User.new
      User.stub!(:find).with(@user.id).and_return(@user)
    end
    def user_is_signed_in
      session[:current_user_id] = @user.id
    end
    def user_is_not_signed_in
      session[:current_user_id] = nil
    end
    it "should set the session and redirect to signup if no current_user" do
      user_is_not_signed_in
      get :donate, @params
      flash[:donated].should be_true
      session[:donated].should be_true
      response.should redirect_to signup_users_path
    end
    it "should redirect to wods_path unless params are right" do
      @params.delete(:tx)
      get :donate, @params
      response.should redirect_to wods_path
      @params = nil
      get :donate
      response.should redirect_to wods_path
    end
    it "should set current_user paid to true and redirect to current user if current_user" do
      user_is_signed_in
      @user.should_receive(:save)
      get :donate, @params
      flash[:donated].should be_true
      @user.paid.should be_true
      response.should redirect_to @user
    end
  end
end
