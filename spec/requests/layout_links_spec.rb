require 'spec_helper'

describe "LayoutLinks" do

  describe "when not signed in" do
    it "should have a Contact page at '/contact'" do
      get '/contact'
      response.should have_selector("title", :content => I18n.t('titles.contact') )
    end

    it "should have an About page at '/about'" do
      get '/about'
      response.should have_selector("title", :content => I18n.t('titles.about') )
    end

    it "should have a Contact page at '/signup'" do
      get '/signup'
      response.should have_selector("title", :content => I18n.t('titles.sign_up') )
    end

    it "should have a Sign in page at '/signin'" do
      get '/signin'
      response.should have_selector("title", :content => I18n.t('titles.sign_in') )
    end

    it "should have the right links on the main layout" do
      visit root_path
      click_link I18n.t('links.home')
      response.should have_selector("title", :content => I18n.t('titles.about') )
      click_link I18n.t('links.contact')
      response.should have_selector("title", :content => I18n.t('titles.contact') )
    end

    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => I18n.t('links.sign_in') )
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      visit signin_path
      fill_in I18n.t('sessions.new.email'), :with => @user.email
      fill_in I18n.t('sessions.new.password'), :with => @user.password
      click_button
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => I18n.t('links.sign_out') )
    end

    it "should have the right links on the main layout" do
      visit root_path
      click_link I18n.t('links.home')
      response.should have_selector("title", :content => "#{@user.surname}")
    end

    it "should have the right links on the 'home' layout" do
      click_link I18n.t('links.my_page')
      response.should have_selector("title", :content => "#{@user.surname}")
      click_link I18n.t('links.settings')
      response.should have_selector("title", :content => I18n.t('titles.user_edit') )
      click_link I18n.t('links.storages')
      response.should have_selector("title", :content => I18n.t('titles.storages') )
      click_link I18n.t('links.articles')
      response.should have_selector("title", :content => I18n.t('titles.articles') )
      click_link I18n.t('links.users')
      response.should have_selector("title", :content => I18n.t('titles.users') )
      click_link I18n.t('links.about')
      response.should have_selector("title", :content => I18n.t('titles.about') )
    end
  end

end
