require 'spec_helper'

describe ArticlesController do
  render_views

  describe "GET 'index'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
      @article = FactoryGirl.create(:article, :user => @admin, :content => "Sample text")
    end

    describe "for non-signed-in user" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      describe "as an non-admin user" do
        before(:each) do
          test_sign_in(@user)
        end

        it "should be successful" do
          get :index
          response.should be_success
        end

        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => I18n.t('titles.articles'))
        end

        it "should show the articles" do
          article1 = FactoryGirl.create(:article, :user => @admin, :content => "Sample text 1")
          article2 = FactoryGirl.create(:article, :user => @admin, :content => "Sample text 2")
          get :index
          response.should have_selector("div.articles.content", :content => article1.content)
          response.should have_selector("div.articles.content", :content => article2.content)
        end

        it "should paginate articles" do
          articles = []

          5.times do
            articles << FactoryGirl.create(:article, :user => @admin, :content => "Sample text")
          end

          get :index
          response.should have_selector("div.pagination")
          response.should have_selector("span.disabled", :content => I18n.t('will_paginate.previous_label'))
          response.should have_selector("a", :href => "/articles?page=2", :content => "2")
          response.should have_selector("a", :href => "/articles?page=2", :content => I18n.t('will_paginate.next_label'))
        end

        it "should not have 'new article' link" do
          get :index
          response.should_not have_selector("a", :content => I18n.t('articles.index.new'))
        end

        it "should not have 'edit' links" do
          get :index
          response.should_not have_selector("a", :content => I18n.t('articles.article.edit'))
        end

        it "should not have 'delete' links" do
          get :index
          response.should_not have_selector("a", :content => I18n.t('articles.article.delete'))
        end
      end

      describe "as an admin user" do
        before(:each) do
          test_sign_in(@admin)
        end

        it "should have 'new article' link" do
          get :index
          response.should have_selector("a", :content => I18n.t('articles.index.new'))
        end

        it "should have 'edit' links" do
          get :index
          response.should have_selector("a", :content => I18n.t('articles.article.edit'))
        end

        it "should have 'delete' links" do
          get :index
          response.should have_selector("a", :content => I18n.t('articles.article.delete'))
        end
      end
    end
  end

  ##############################################

  describe "GET 'new'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
    end

    describe "for non-signed-in user" do
      it "should deny access" do
        get :new
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in user" do
      describe "as a non-admin user" do
        it "should protect the page" do
          test_sign_in(@user)
          get :new
          response.should redirect_to(articles_path)
        end
      end

      describe "as an admin user" do
        before(:each) do
          test_sign_in(@admin)
        end

        it "should have the right title" do
          get :new
          response.should have_selector("title", :content => I18n.t('titles.publication'))
        end

        it "should have a textarea" do
          get :new
          response.should have_selector("textarea[name='article[content]']")
        end
      end
    end
  end

  ##############################################

  describe "POST 'create'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
    end

    describe "for non-signed-in user" do
      it "should deny access" do
        post :create, :article => { :content => "Sample text" }
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in user" do
      describe "as a non-admin user" do
        it "should protect the action" do
          test_sign_in(@user)
          post :create, :article => { :content => "Sample text" }
          response.should redirect_to(articles_path)
        end
      end

      describe "as an admin user" do
        before(:each) do
          test_sign_in(@admin)
        end

        it "should not create a new article" do
          lambda do
            post :create, :article => { :content => "" }
          end.should_not change(Article, :count)
        end

        it "should create a new article" do
          lambda do
            post :create, :article => { :content => "Sample text" }
          end.should change(Article, :count).by(1)
        end
      end
    end
  end

  ##############################################

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
      @article = FactoryGirl.create(:article, :user => @admin, :content => "Sample text")
    end

    describe "for non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @article
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in user" do
      describe "as a non-admin user" do
        it "should protect the action" do
          test_sign_in(@user)
          delete :destroy, :id => @article
          response.should redirect_to(articles_path)
        end
      end

      describe "as an admin user" do
        before(:each) do
          test_sign_in(@admin)
        end

        it "should destroy the article" do
          lambda do
            delete :destroy, :id => @article
          end.should change(Article, :count).by(-1)
        end

        it "should redirect to the articles page" do
          delete :destroy, :id => @article
          response.should redirect_to(articles_path)
        end
      end
    end
  end

  ##############################################

  describe "GET 'edit'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
      @article = FactoryGirl.create(:article, :user => @admin, :content => "Sample text")
    end

    describe "for non-signed-in user" do
      it "should protect the action" do
        get :edit, :id => @article
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in user" do
      describe "as a non-admin user" do
        it "should protect the action" do
          test_sign_in(@user)
          get :edit, :id => @article
          response.should redirect_to(articles_path)
        end
      end

      describe "as an admin user" do
        before(:each) do
          test_sign_in(@admin)
        end

        it "should be successful" do
          get :edit, :id => @article
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @article
          response.should have_selector("title", :content => I18n.t('titles.article_edit'))
        end
      end
    end
  end

  ##############################################

  describe "PUT 'update'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, :email => "admin@example.com", :admin => true)
      @article = FactoryGirl.create(:article, :user => @admin, :content => "Sample text")
      @attr = { :content => "New text" }      
    end

    describe "for non-signed-in user" do
      it "should deny access" do
        put :update, :id => @article, :article => @attr
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      describe "as non-admin user" do 
        it "should redirect to articles path" do
          test_sign_in(@user)
          put :update, :id => @article, :article => @attr
          response.should redirect_to(articles_path)
        end
      end

      describe "as an admin user" do
        describe "failure" do
          before(:each) do
            test_sign_in(@admin)
            @empty_attr = { :content => "" }
          end

          it "should render the 'edit' page" do
            put :update, :id => @article, :article => @empty_attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @article, :article => @empty_attr
            response.should have_selector("title", :content => I18n.t('titles.article_edit'))
          end                
        end

        describe "success" do
          before(:each) do
            test_sign_in(@admin)
            @new_attr = { :content => "another text" }
          end

          it "should change the attributes" do
            put :update, :id => @article, :article => @new_attr
            @article.reload
            @article.content.should == @new_attr[:content]
          end

          it "should redirect to the storage show page" do
            put :update, :id => @article, :article => @new_attr
            response.should redirect_to(articles_path)
          end
        end        
      end
    end
  end

  ##############################################

end
