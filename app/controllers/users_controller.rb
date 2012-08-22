class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @title = "#{@user.surname} #{@user.initials.first}. #{@user.initials.last}."
  end

  def new
    @user = User.new
    @title = t('titles.sign_up')
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = t('flash.success.welcome')
      redirect_to @user
    else
      @title = t('titles.sign_up')
      flash.now[:error] = t('flash.error.registration')
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = t('titles.edit')
  end

end
