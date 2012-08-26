class ArticlesController < ApplicationController

  before_filter :authenticate, :only => [:index, :new, :create, :destroy]
  before_filter :admin_user,   :only => [:new, :create, :destroy]

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
    @article = Article.new
    @title = t('titles.publication')
  end

  def create
    @article = current_user.articles.build(params[:article])
    if @article.save
      flash[:success] = t('flash.success.published')
      redirect_to articles_path
    else
      @title = t('titles.articles')
      flash.now[:error] = t('flash.error.publication')
      render 'new'
    end
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
      redirect_to(articles_path) unless current_user.admin?
    end

end
