class SessionsController < ApplicationController

  def new
    @title = t('titles.sign_in')
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] =  t('flash.error.login')
      @title = t('titles.sign_in')
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
