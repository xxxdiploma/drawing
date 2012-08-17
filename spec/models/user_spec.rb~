require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :surname => "Example",
      :initials => "UR",
      :email => "user@example.com"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

	it "should require a name" do
    no_name_user = User.new(@attr.merge(:surname => ""))
    no_name_user.should_not be_valid
  end

 it "should require an initials" do
    no_initials_user = User.new(@attr.merge(:initials => ""))
    no_initials_user.should_not be_valid
  end

	it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  #######################################

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:surname => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject initials that are too long" do
    long_initials = "AAA"
    long_initials_user = User.new(@attr.merge(:initials => long_initials))
    long_initials_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

end
