class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @title = "#{@user.surname} #{@user.initials.first}. #{@user.initials.last}."
  end

  def new
    @user = User.new
    @title = t('pages.sign_up.title')
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = t('flash.success.welcome')
      redirect_to @user
    else
      @title = t('pages.sign_up.title')
      render 'new'
    end
  end

end
