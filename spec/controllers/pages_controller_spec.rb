require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    it "should redirect to about path if not signed in" do
      get 'home'
      response.should redirect_to(about_path)
    end

    it "should redirect to current user path path if signed in" do
      user = FactoryGirl.create(:user, :id => 1)
      test_sign_in(user)
      get 'home'
      response.should redirect_to('/users/1')
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end

 	  it "should have the right title" do
      get 'about'
    	response.should have_selector("title", :content => I18n.t('titles.about') )
  	end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
		  get 'contact'
    	response.should have_selector("title", :content => I18n.t('titles.contact') )
  	end
  end

end
