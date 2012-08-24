class SessionsController < ApplicationController

  before_filter :signed_in_user, :only => [:new]

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
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

    def signed_in_user
      if signed_in?
        flash[:notice] = t('flash.notice.already_signed_in')
        redirect_to(current_user)
      end
    end

end
