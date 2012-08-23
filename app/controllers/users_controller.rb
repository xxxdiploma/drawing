class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index, :show, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy]

  def index
    @users = User.paginate(:page => params[:page], :per_page => 15 )
    @title = t('titles.users')
  end

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
    @title = t('titles.edit')
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = t('flash.success.updated')
      redirect_to @user
    else
      @title = t('titles.edit')
      flash.now[:error] = t('flash.error.not_updated')
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('flash.success.destroyed')
    redirect_to users_path
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
