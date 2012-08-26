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

    describe "as an admin user" do

      it "should have 'delete' links" do
        admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
        FactoryGirl.create(:article, :user => admin, :content => "Sample text")
        test_sign_in(admin)
        get :index
        response.should have_selector("a", :content => I18n.t('articles.index.delete'))
      end
    end

    describe "as an non-admin user" do

      it "should have 'delete' links" do
        user = FactoryGirl.create(:user)
        FactoryGirl.create(:article, :user => user, :content => "Sample text")
        test_sign_in(user)
        get :index
        response.should_not have_selector("a", :content => I18n.t('articles.index.delete'))
      end
    end
  end

  ##############################################

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @article = FactoryGirl.create(:article, :user => @user, :content => "Sample text")
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @article
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @article
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy the article" do
        lambda do
          delete :destroy, :id => @article
        end.should change(Article, :count).by(-1)
      end

      it "should redirect to the articles page" do
        delete :destroy, :id => @article
        response.should redirect_to(articles_path)
      end
    end
  end

end
