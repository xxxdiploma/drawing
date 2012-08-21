class PagesController < ApplicationController

  def home
  	@title = t('titles.home')
  end

  def contact
    @title = t('titles.contact')
  end

end
