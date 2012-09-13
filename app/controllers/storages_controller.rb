class StoragesController < ApplicationController

  before_filter :authenticate
  before_filter :admin_user, :except => [:index]

  def index
    @title = t('titles.storages')
    @storages = Storage.paginate(:page => params[:page], :per_page => 15 )
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
    return redirect_to(:action => 'authorize') if not session[:db_ready]

    if not params[:file]
      flash[:error] =  t('flash.error.empty_file')
      return redirect_to(:action => 'index')
    end

    client = Dropbox::API::Client.new(:token => session[:db_token], :secret => session[:db_secret])

    # Saving a file #

    file = client.upload(params[:file].original_filename, params[:file].read)

    current_file = current_user.storages.build(:file_name => params[:file].original_filename,
                                               :url => file.share_url[:url], :description => "empty")
    current_file.save

    #################

    flash[:success] = t('flash.success.file_uploaded')
    redirect_to(:action => 'index')
  end

  def destroy
    return redirect_to(:action => 'authorize') if not session[:db_ready]

    client = Dropbox::API::Client.new(:token => session[:db_token], :secret => session[:db_secret])

    # Destroying a file #

    current_file = Storage.find(params[:id])

    client.find(current_file.file_name).destroy
    current_file.destroy

    #####################

    flash[:success] = t('flash.success.file_destroyed')
    redirect_to(:action => 'index')
  end


  private

    def admin_user
      redirect_to(storages_path) unless current_user.admin?
    end

end
