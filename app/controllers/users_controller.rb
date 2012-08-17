class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @title = "#{@user.surname} #{@user.initials.first}. #{@user.initials.last}."
  end

  def new
    @title = t('users.sign_up.title')
  end

end