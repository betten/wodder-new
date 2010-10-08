require 'test_helper'

class WodsControllerTest < ActionController::TestCase
  test "should get all" do
    get :all
    assert_response :success
  end

  test "should get gym" do
    get :gym
    assert_response :success
  end

  test "should get user" do
    get :user
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

end
