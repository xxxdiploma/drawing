class ApplicationController < ActionController::Base
  before_filter :set_timezone

  protect_from_forgery
  include SessionsHelper

  def set_timezone
    Time.zone = current_user.timezone if current_user
  end
end
