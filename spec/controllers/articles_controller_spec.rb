require 'spec_helper'

describe ArticlesController do
  render_views

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should == I18n.t('flash.notice.deny_access')
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user = FactoryGirl.create(:user)
        test_sign_in(@user)
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => I18n.t('titles.articles') )
      end

      it "should show the articles" do
        mp1 = FactoryGirl.create(:article, :user => @user, :content => "Sample text")
        mp2 = FactoryGirl.create(:article, :user => @user, :content => "Sample text")
        get :index
        response.should have_selector("div.articles.content", :content => mp1.content)
        response.should have_selector("div.articles.content", :content => mp2.content)
      end
    end
  end

end
