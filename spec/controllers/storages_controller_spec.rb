require 'spec_helper'

describe StoragesController do
  render_views

  describe "GET 'index'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      before(:each) do
        test_sign_in(@user)
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => I18n.t('titles.storages') )
      end
    end
  end

end
