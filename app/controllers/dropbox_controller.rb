class DropboxController < ApplicationController

  def authorize
    if not params[:oauth_token] then
      consumer = Dropbox::API::OAuth.consumer(:authorize)
      request_token = consumer.get_request_token
      session[:db_token] = request_token.token
      session[:db_secret] = request_token.secret
      redirect_to request_token.authorize_url(:oauth_callback => url_for(:action => 'authorize'))
    else
      consumer = Dropbox::API::OAuth.consumer(:authorize)
      request_token = OAuth::RequestToken.new(consumer, session[:db_token], session[:db_secret])
      access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_token])
      session[:db_token] = access_token.token
      session[:db_secret] = access_token.secret
      session[:db_ready] = "ready"

      return redirect_to(:action => 'upload')
    end
  end

  def upload
    return redirect_to(:action => 'authorize') if not session[:db_ready]

    @client = Dropbox::API::Client.new(:token => session[:db_token], :secret => session[:db_secret])

    @client.search('test.txt').each do |file|
      file.copy(file.path + ".old2")
    end

    flash.now[:success] = "Update successful!"
    render 'index'

  end
end
