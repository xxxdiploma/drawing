class PagesController < ApplicationController

  def home
  	@title = t('pages.home.title')
  end

  def contact
    @title = t('pages.contact.title')
  end
end
