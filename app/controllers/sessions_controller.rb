class SessionsController < ApplicationController

  def new
    @title = t('pages.sign_in.title')
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] =  t('flash.error.login')
      @title = t('pages.sign_in.title')
      render 'new'
    else
      sign_in user
      redirect_to user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
