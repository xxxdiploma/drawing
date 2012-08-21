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
end
