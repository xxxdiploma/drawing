# == Schema Information
#
# Table name: storages
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  file_name   :string(255)      not null
#  url         :string(255)      not null
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Storage do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = { 
      :url => "http://file.test",
      :title => "test file",
      :description => "description",
      :file_name => "test.txt" 
    }
  end

  it "should create a new instance given valid attributes" do
    @user.storages.create!(@attr)
  end

  it "should require a file name" do
    no_name_file = Storage.new(@attr.merge(:file_name => ""))
    no_name_file.should_not be_valid
  end

  it "should require a title" do
    no_title_file = Storage.new(@attr.merge(:title => ""))
    no_title_file.should_not be_valid
  end

  it "should require an url" do
    no_url_file = Storage.new(@attr.merge(:url => ""))
    no_url_file.should_not be_valid
  end  

  describe "user associations" do

    before(:each) do
      @file = @user.storages.create(@attr)
    end

    it "should have a user attribute" do
      @file.should respond_to(:user)
    end

    it "should have the right associated user" do
      @file.user_id.should == @user.id
      @file.user.should == @user
    end
  end  

  describe "validations" do

    it "should require a user id" do
      Storage.new(@attr).should_not be_valid
    end

    it "should require nonblank tittle" do
      @user.storages.build(:title => "  ").should_not be_valid
    end

    it "should reject short tittle" do
      @user.storages.build(:title => "aa").should_not be_valid
    end

    it "should reject long tittle" do
      @user.storages.build(:title => "a" * 151).should_not be_valid
    end

    it "should require nonblank file name" do
      @user.storages.build(:file_name => "  ").should_not be_valid
    end

    it "should reject short file name" do
      @user.storages.build(:file_name => "aa").should_not be_valid
    end

    it "should reject long file name" do
      @user.storages.build(:file_name => "a" * 151).should_not be_valid
    end    

    it "should reject long description" do
      @user.storages.build(:description => "a" * 1001).should_not be_valid
    end        

  end


end
