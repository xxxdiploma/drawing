require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
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

  describe "GET 'new'" do
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

  describe "POST 'create'" do

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

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should == I18n.t('flash.success.welcome')
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => I18n.t('titles.edit') )
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
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
        response.should have_selector("title", :content => I18n.t('titles.edit') )
      end
    end

    describe "success" do

      before(:each) do
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

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should == I18n.t('flash.success.updated')
      end
    end
  end

  describe "authentication of edit/update/show pages" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'show'" do
        get :show, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do

      before(:each) do
        wrong_user = FactoryGirl.create(:user, :email => "wrong@user.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end

end
