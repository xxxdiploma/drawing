require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector("title", :content => I18n.t('titles.home') )
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector("title", :content => I18n.t('titles.contact') )
  end

  it "should have a Contact page at '/signup'" do
    get '/signup'
    response.should have_selector("title", :content => I18n.t('titles.sign_up') )
  end

  it "should have a Sign in page at '/signin'" do
    get '/signin'
    response.should have_selector("title", :content => I18n.t('titles.sign_in') )
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link I18n.t('links.home')
    response.should have_selector("title", :content => I18n.t('titles.home') )
    click_link I18n.t('links.contact')
    response.should have_selector("title", :content => I18n.t('titles.contact') )
  end

  describe "when not signed in" do
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

    it "should have a profile link"
      # Заполнить позже


    it "should have an edit link"
      # Заполнить позже


    it "should have an articles link"
      # Заполнить позже


    it "should have a users link"
      # Заполнить позже

  end

end
