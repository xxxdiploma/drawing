class ArticlesController < ApplicationController

  before_filter :authenticate
  before_filter :admin_user, :except => [:index]

  def index
    @title = t('titles.articles')
    @articles = Article.paginate(:page => params[:page], :per_page => 3 )
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
    if current_user.admin?
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
  end

  def edit
    @article = Article.find(params[:id])
    @title = t('titles.article_edit')
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:success] = t('flash.success.article_updated')
      redirect_to articles_path
    else
      @title = t('titles.article_edit')
      flash.now[:error] = t('flash.error.publication')
      render 'edit'
    end
  end

  private

    def admin_user
      redirect_to(articles_path) unless current_user.admin?
    end

end
