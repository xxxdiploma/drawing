require 'spec_helper'

describe StoragesController do

  describe "for signed-in users" do
    before(:each) do
      @user = test_sign_in(FactoryGirl.create(:user))
      test_sign_in(@user)
    end

    describe "GET 'index'" do
      it "should be successful" do
        get :index
        response.should be_success
      end
    end
  end

end
