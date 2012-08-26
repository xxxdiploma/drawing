class ArticlesController < ApplicationController

  before_filter :authenticate, :only => [:index, :destroy]
  before_filter :admin_user,   :only => [:destroy]

  def index
    @title = t('titles.articles')
    @articles = Article.all
  end

  def destroy
    Article.find(params[:id]).destroy
    flash[:success] = t('flash.success.article_destroyed')
    redirect_to articles_path
  end

  def new
    #Заполнить позже
  end

  def show
    #Заполнить позже
  end

  def edit
    #Заполнить позже
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
