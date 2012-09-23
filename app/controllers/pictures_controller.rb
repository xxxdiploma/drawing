class PicturesController < ApplicationController
  def new
    @picture = Picture.new
    @title = "Create new picture"
  end
end
