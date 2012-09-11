class StoragesController < ApplicationController

  before_filter :authenticate
  before_filter :admin_user, :except => [:index]

  def index
    @title = t('titles.storages')
  end

  def authorize
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    if not params[:oauth_token] then
      request_token = consumer.get_request_token
      session[:db_token] = request_token.token
      session[:db_secret] = request_token.secret

      redirect_to request_token.authorize_url(:oauth_callback => url_for(:action => 'authorize'))
    else
      request_token = OAuth::RequestToken.new(consumer, session[:db_token], session[:db_secret])
      access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_token])
      session[:db_token] = access_token.token
      session[:db_secret] = access_token.secret
      session[:db_ready] = "ready"

      redirect_to(:action => 'index')
    end
  end

  def upload
    client = Dropbox::API::Client.new(:token => session[:db_token], :secret => session[:db_secret])
    file = client.upload(params[:file].original_filename, params[:file].read)

    flash[:success] = t('flash.success.file_uploaded')

    redirect_to(:action => 'index')
  end

  private

    def admin_user
      redirect_to(storages_path) unless current_user.admin?
    end

end
