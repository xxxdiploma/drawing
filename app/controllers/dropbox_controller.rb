require 'dropbox_sdk'

class DropboxController < ApplicationController
  def authorize
    if not params[:oauth_token] then
      dbsession = DropboxSession.new(ENV["DB_APP_KEY"], ENV["DB_APP_SECRET"])
      session[:dropbox_session] = dbsession.serialize

      redirect_to dbsession.get_authorize_url url_for(:action => 'authorize')
    else
      dbsession = DropboxSession.deserialize(session[:dropbox_session])
      dbsession.get_access_token
      session[:dropbox_session] = dbsession.serialize

      redirect_to :action => 'upload'
    end
  end

  def upload
    return redirect_to(:action => 'authorize') unless session[:dropbox_session]

    dbsession = DropboxSession.deserialize(session[:dropbox_session])
    client = DropboxClient.new(dbsession, :app_folder)
    info = client.account_info

    resp = client.put_file(params[:file].original_filename, params[:file].read)
    flash.now[:success] = "Upload successful!"
    render 'index'
  end
end
