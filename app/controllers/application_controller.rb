class ApplicationController < ActionController::Base
  protect_from_forgery
  
  @user = User.all

  def user
    
  end
  
end
