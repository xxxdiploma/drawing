require 'spec_helper'

describe StoragesController do
  render_views

  describe "GET 'index'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
      @file = FactoryGirl.create(:storage, :user => @admin, :title => "title")
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      before(:each) do
        test_sign_in(@user)
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => I18n.t('titles.storages') )
      end

      it "should show the storages" do
        get :index
        response.should have_selector("li", :content => @file.title)
      end

      it "should paginate storages" do
        storages = []

        30.times do
          storages << FactoryGirl.create(:storage, :user => @admin, :title => "title")
        end

        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => I18n.t('will_paginate.previous_label'))
        response.should have_selector("a", :href => "/storages?page=2", :content => "2")
        response.should have_selector("a", :href => "/storages?page=2", :content => I18n.t('will_paginate.next_label'))
      end

      it "should not have 'delete' links" do
        get :index
        response.should_not have_selector("a", :content => I18n.t('storages.storage.delete'))
      end
    end

    describe "as an admin user" do
      it "should have an authorization message" do
        test_sign_in(@admin)
        get :index
        response.should have_selector("p", :content => I18n.t('storages.authorize.can_upload'))  
      end

      it "should not have 'delete' links" do
        get :index
        response.should_not have_selector("a", :content => I18n.t('storages.storage.delete'))
      end
    end 
  end

  ##############################################

  describe "GET 'show'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
      @file = FactoryGirl.create(:storage, :user => @admin, :title => "title")
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        get :show, :id => @file
        response.should redirect_to(signin_path)
      end
    end

    describe 'for signed-in users' do
      before(:each) do
        test_sign_in(@user)
      end

      it "should be successful" do
        get :show, :id => @file
        response.should be_success
      end

      it "should find the right storage" do
        get :show, :id => @file
        assigns(:storage).should == @file
      end
   
      it "should have the right title" do
        get :show, :id => @file
        response.should have_selector("title", :content => @file.title)
      end

      it "should not have an edit button" do
        get :show, :id => @file
        response.should_not have_selector("a", :content => I18n.t('storages.show.edit'))  
      end

      it "should have an download button" do
        get :show, :id => @file
        response.should have_selector("a", :content => I18n.t('storages.show.download'))  
      end
    end

    describe "as an admin user" do
      it "should have an edit button" do
        test_sign_in(@admin)
        get :show, :id => @file
        response.should have_selector("a", :content => I18n.t('storages.show.edit'))  
      end
    end 
  end

  ##############################################

  describe "GET 'edit'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
      @file = FactoryGirl.create(:storage, :user => @admin, :title => "title")
    end    

    describe "as a non-signed-in user" do
      it "should deny access" do
        get :edit, :id => @file
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      it "should redirect to storages path" do
        test_sign_in(@user)
        get :edit, :id => @file
        response.should redirect_to(storages_path)
      end
    end

    describe "as an admin user" do
      it "should be successful" do
        test_sign_in(@admin)
        get :edit, :id => @file
        response.should be_success
      end

      it "should have a right title" do
        test_sign_in(@admin)
        get :edit, :id => @file
        response.should have_selector("title", :content => I18n.t('titles.file_edit')) 
      end
    end 

  end

  ##############################################

  describe "PUT 'update'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
      @file = FactoryGirl.create(:storage, :user => @admin, :title => "title")
      @attr = { :title => "new title", :description => "new description" }
    end    

    describe "as a non-signed-in user" do
      it "should deny access" do
        put :update, :id => @file, :storage => @attr
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      it "should redirect to storages path" do
        test_sign_in(@user)
        put :update, :id => @file, :storage => @attr
        response.should redirect_to(storages_path)
      end
    end   

    describe "failure" do

      before(:each) do
        test_sign_in(@admin)
        @empty_attr = { :title => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @file, :storage => @empty_attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @file, :storage => @empty_attr
        response.should have_selector("title", :content => I18n.t('titles.file_edit'))
      end
    end

    describe "success" do

      before(:each) do
        test_sign_in(@admin)
        @new_attr = { :title => "another title" }
      end

      it "should change the attributes" do
        put :update, :id => @file, :storage => @new_attr
        @file.reload
        @file.title.should  == @new_attr[:title]
      end

      it "should redirect to the storage show page" do
        put :update, :id => @file, :storage => @new_attr
        response.should redirect_to(storage_path(@file))
      end
    end
  end

end
