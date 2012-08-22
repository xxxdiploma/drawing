require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do
      it "should not make a new user" do
        lambda do
		      visit signup_path
		      fill_in I18n.t('activerecord.attributes.user.surname'), :with => ""
		      fill_in I18n.t('activerecord.attributes.user.initials'), :with => ""
		      fill_in I18n.t('activerecord.attributes.user.email'), :with => ""
		      fill_in I18n.t('activerecord.attributes.user.password'), :with => ""
		      fill_in I18n.t('activerecord.attributes.user.password_confirmation'), :with => ""
		      click_button
		      response.should render_template('users/new')
		      response.should have_selector("div#error_explanation")
		    end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in I18n.t('activerecord.attributes.user.surname'), :with => "Example"
          fill_in I18n.t('activerecord.attributes.user.initials'), :with => "UR"
          fill_in I18n.t('activerecord.attributes.user.email'), :with => "user@example.com"
          fill_in I18n.t('activerecord.attributes.user.password'), :with => "foobar"
          fill_in I18n.t('activerecord.attributes.user.password_confirmation'), :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => I18n.t('flash.success.welcome') )
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in I18n.t('sessions.new.email'), :with => ""
        fill_in I18n.t('sessions.new.password'), :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => I18n.t('flash.error.login') )
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = FactoryGirl.create(:user)
        visit signin_path
        fill_in I18n.t('sessions.new.email'), :with => user.email
        fill_in I18n.t('sessions.new.password'), :with => user.password
        click_button
        controller.should be_signed_in
        click_link I18n.t('links.sign_out')
        controller.should_not be_signed_in
      end
    end
  end
end
