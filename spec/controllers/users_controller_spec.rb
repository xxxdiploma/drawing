require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      describe "as an non-admin user" do
        before(:each) do
          test_sign_in(@user)
          @users = []

          30.times do
            @users << FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
          end
        end

        it "should be successful" do
          get :index
          response.should be_success
        end

        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => I18n.t('titles.users') )
        end

        it "should have an element for each user" do
          get :index
          @users.each do |user|
            response.should have_selector("li", :content => user.surname)
          end
        end

        it "should have an element for each user" do
          get :index
          @users[0..2].each do |user|
            response.should have_selector("li", :content => user.surname)
          end
        end

        it "should paginate users" do
          get :index
          response.should have_selector("div.pagination")
          response.should have_selector("span.disabled", :content => I18n.t('will_paginate.previous_label'))
          response.should have_selector("a", :href => "/users?page=2", :content => "2")
          response.should have_selector("a", :href => "/users?page=2", :content => I18n.t('will_paginate.next_label'))
        end

        it "should not have 'delete' links" do
          get :index
          response.should_not have_selector("a", :content => I18n.t('users.user.delete'))
        end
      end

      describe "as an admin user" do
        it "should have 'delete' links" do
          @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
          test_sign_in(@admin)
          get :index
          response.should have_selector("a", :content => I18n.t('users.user.delete'))
        end 
      end
    end
  end

  ##############################################

  describe "GET 'show'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed-in users" do
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
        get :show, :id => @user
        response.should be_success
      end

      it "should find the right user" do
        get :show, :id => @user
        assigns(:user).should == @user
      end

      it "should have the right title" do
        get :show, :id => @user
        response.should have_selector("title", :content => @user.surname)
      end
    end
  end

  ##############################################

  describe "GET 'new'" do
    describe "for non-signed-in users" do
      it "returns http success" do
        get :new
        response.should be_success
      end

      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => I18n.t('titles.sign_up') )
      end

      it "should have a surname field" do
        get :new
        response.should have_selector("input[name='user[surname]'][type='text']")
      end

      it "should have an initials field" do
        get :new
        response.should have_selector("input[name='user[initials]'][type='text']")
      end

      it "should have an email field" do
        get :new
        response.should have_selector("input[name='user[email]'][type='text']")
      end

      it "should have a password field" do
        get :new
        response.should have_selector("input[name='user[password]'][type='password']")
      end

      it "should have a password confirmation field" do
        get :new
        response.should have_selector("input[name='user[password_confirmation]'][type='password']")
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        test_sign_in(@user)
      end

      it "should redirect to the user show page" do
        get :new
        response.should redirect_to(user_path(@user))
      end
    end
  end

  ##############################################

  describe "POST 'create'" do
    describe "for non-signed-in user" do    
      describe "failure" do
        before(:each) do
          @attr = { :surname => "", :initials =>"", 
                    :email => "", :password => "", 
                    :password_confirmation => "" }
        end

        it "should not create a user" do
          lambda do
            post :create, :user => @attr
          end.should_not change(User, :count)
        end

        it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector("title", :content => I18n.t('titles.sign_up') )
        end

        it "should render the 'new' page" do
          post :create, :user => @attr
          response.should render_template('new')
        end
      end

      describe "success" do
        before(:each) do
          @attr = { :surname => "Example", :initials => "UR",
                    :email => "user@example.com", :password => "foobar",
                    :password_confirmation => "foobar" }
        end

        it "should create a user" do
          lambda do
            post :create, :user => @attr
          end.should change(User, :count).by(1)
        end

        it "should redirect to the user show page" do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end

        it "should sign the user in" do
          post :create, :user => @attr
          controller.should be_signed_in
        end
      end
    end

    describe "for signed-in user" do
      it "should protect the action" do
        @user = FactoryGirl.create(:user)
        @attr = { :surname => "Another", :initials => "UR",
                  :email => "user@example.com", :password => "foobar",
                  :password_confirmation => "foobar" }
        test_sign_in(@user)

        post :create, :user => @attr
        response.should redirect_to(user_path(@user))
      end
    end
  end

  ##############################################

  describe "GET 'edit'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed-in user" do
      it "should deny access" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in user" do
      before(:each) do
        test_sign_in(@user)
      end

      it "should be successful" do  
        get :edit, :id => @user
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector("title", :content => I18n.t('titles.user_edit'))
      end

      it "should require matching users for action" do
        wrong_user = FactoryGirl.create(:user, :email => "wrong@user.net")
        test_sign_in(wrong_user)
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
    end
  end

  ##############################################

  describe "PUT 'update'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed-in user" do
      it "should deny access" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      describe "failure" do
        before(:each) do
          test_sign_in(@user)
          @attr = { :surname => "", :initials => "",
                    :password => "", :email => "",
                    :password_confirmation => "" }
        end

        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => I18n.t('titles.user_edit') )
        end
      end

      describe "success" do
        before(:each) do
          test_sign_in(@user)
          @attr = { :surname => "Example", :initials => "UR",
                    :email => "user@example.org", :password => "barbaz",
                    :password_confirmation => "barbaz" }
        end

        it "should change the user's attributes" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.surname.should  == @attr[:surname]
          @user.email.should == @attr[:email]
        end

        it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(@user))
        end
      end

      it "should require matching users for action" do
        wrong_user = FactoryGirl.create(:user, :email => "wrong@user.net")
        test_sign_in(wrong_user)        
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end

  ##############################################

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      describe "as a non-admin user" do
        it "should protect the page" do
          test_sign_in(@user)
          delete :destroy, :id => @user
          response.should redirect_to(root_path)
        end
      end

      describe "as an admin user" do
        before(:each) do
          @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
          test_sign_in(@admin)
        end

        it "should destroy the user" do
          lambda do
            delete :destroy, :id => @user
          end.should change(User, :count).by(-1)
        end

        it "should redirect to the users page" do
          delete :destroy, :id => @user
          response.should redirect_to(users_path)
        end

        it "should not be able to destroy yourself" do
          lambda do
            delete :destroy, :id => @admin
          end.should_not change(User, :count)
        end
      end
    end
  end

  ##############################################

end
