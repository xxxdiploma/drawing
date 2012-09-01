class PagesController < ApplicationController

  def home
    if signed_in?
  	  redirect_to current_user
    else
      redirect_to about_path
    end
  end

  def about
    @title = t('titles.about')
  end

  def contact
    @title = t('titles.contact')
  end

end
