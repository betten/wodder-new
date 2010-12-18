require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "username should not have spaces" do
    u = User.new
    u.email = "test@test.com"
    u.username = "hello world"
    assert !u.save
  end
end
