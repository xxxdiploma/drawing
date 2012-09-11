module DropboxHelper
  def dropbox_user
    session[:db_ready]
  end
end
