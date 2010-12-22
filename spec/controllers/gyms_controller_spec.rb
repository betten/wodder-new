require 'spec_helper'

describe GymsController do
  describe "new add create" do
    # new and add do the same thing in the controller, just render different templates, TODO could probably be merged into one action
    # create should behave differently depending on whether current_user is admin
    describe "create" do
      before do
        @user = User.new
        User.stub!(:find).and_return(@user)
        session[:current_user_id] = @user.id
        @gym = Gym.new
        Gym.should_receive(:new).and_return(@gym)
      end
      def user_is_admin
        @user.admin = true
      end
      it "should create a new gym and set approved to false for non admin" do
        @gym.approved = true
        post :create
        @gym.approved.should be false
      end
      it "should create new gym and not change approved for admin" do
        @gym.approved = true
        user_is_admin
        post :create
        @gym.approved.should be true
      end
      it "should redirect to gym if save success and current_user.is_admin?" do
        user_is_admin
        @gym.should_receive(:save).and_return(true)
        post :create
        response.should redirect_to(@gym)
      end 
      it "should flash and render new if save success and current_user is not admin" do
        @gym.should_receive(:save).and_return(true)
        post :create
        response.should render_template(:new)
        flash[:created].should be_true
      end
      it "should render add if save fails and current_user.is_admin?" do
        user_is_admin
        @gym.should_receive(:save).and_return(false)
        post :create
        response.should render_template(:add)
      end
      it "should render new if save fails and current_user is not admin" do
        @gym.should_receive(:save).and_return(false)
        post :create
        response.should render_template(:new)
      end
    end
  end
end
