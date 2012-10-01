class PicturesController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:destroy, :edit, :update]

  def new
    @picture = Picture.new
    @title = t('titles.picture_new')
  end

  def create
    @picture = current_user.pictures.build(params[:picture])
    if @picture.save
      flash[:success] = t('flash.success.picture_saved')
      redirect_to current_user
    else
      @title = t('titles.picture_new')
      flash.now[:error] = t('flash.error.picture_not_saved')
      render 'new'
    end
  end

  def edit
    @picture = Picture.find(params[:id])
    @title = "edit"
  end

  def update
    @picture = Picture.find(params[:id])
    if @picture.update_attributes(params[:picture])
      flash[:success] = "updated"
      redirect_to root_path
    else
      @title = "edit"
      flash.now[:error] = "error"
      render 'edit'
    end
  end

  def destroy
    Picture.find(params[:id]).destroy
    flash[:success] = "destroyed"
    redirect_to current_user
  end

private

  def correct_user
    id = Picture.find(params[:id]).user_id
    @user = User.find(id)
    redirect_to(root_path) unless current_user?(@user)
  end  

end
