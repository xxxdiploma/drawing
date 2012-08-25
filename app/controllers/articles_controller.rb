class ArticlesController < ApplicationController

  before_filter :authenticate, :only => [:index]

  def index
    @title = t('titles.articles')
    @articles = Article.all
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

end
