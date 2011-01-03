require 'spec_helper'

describe Wod do
  describe "upvote" do
    before do
      @user = User.new
      @wod = Wod.new
    end
    it "should take User object, add user to points_from, and increment points by 1" do
      expect {
        @wod.should_receive(:save).and_return(true)
        @wod.upvote(@user).should be_true
      }.to change { @wod.points }.by(1) and change { @wod.points_from.count }.by(1)
    end
    it "should take a String, add user to points_from, and increment points by 1" do
      expect {
        User.should_receive(:find).and_return(@user)
        @wod.should_receive(:save).and_return(true)
        @wod.upvote(@user.id).should be_true
      }.to change { @wod.points }.by(1) and change { @wod.points_from.count }.by(1)
    end
    it "should return false if by_user is not a user or string" do
      @wod.upvote([]).should be_false
      @wod.upvote({}).should be_false
    end
    it "should return false if user is not admin and has already voted" do
      @wod.points_from << @user.id
      @wod.upvote(@user).should be_false
    end
    it "should always upvote if user is admin" do
      @wod.points_from << @user.id
      @user.admin = true
      @wod.should_receive(:save).and_return(true)
      @wod.upvote(@user).should be_true
    end
  end
end
