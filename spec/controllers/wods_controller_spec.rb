require 'spec_helper'

describe WodsController do
  describe "saving and saved wods" do
    it "should not allow not signed in users to save wods" do
      get :saved
      response.should be_redirect
    end
  end
end
