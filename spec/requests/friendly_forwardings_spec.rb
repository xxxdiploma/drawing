require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signin" do
    user = FactoryGirl.create(:user)
    visit edit_user_path(user)
    fill_in I18n.t('sessions.new.email'), :with => user.email
    fill_in I18n.t('sessions.new.password'), :with => user.password
    click_button
    response.should render_template('users/edit')
  end
end
