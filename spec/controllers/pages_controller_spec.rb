require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end

 	  it "should have the right title" do
      get 'home'
    	response.should have_selector("title", :content => I18n.t('titles.home') )
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
