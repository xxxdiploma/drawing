require 'spec_helper'

describe Article do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = { :content => "Sample text" }
  end

  it "should create a new instance given valid attributes" do
    @user.articles.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @article = @user.articles.create(@attr)
    end

    it "should have a user attribute" do
      @article.should respond_to(:user)
    end

    it "should have the right associated user" do
      @article.user_id.should == @user.id
      @article.user.should == @user
    end
  end

  describe "validations" do

    it "should require a user id" do
      Article.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.articles.build(:content => "  ").should_not be_valid
    end

    it "should reject long content" do
      @user.articles.build(:content => "a" * 5001).should_not be_valid
    end
  end

end
