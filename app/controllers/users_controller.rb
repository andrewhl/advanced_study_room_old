class UsersController < ApplicationController
  def index
    
    @users = User.all
      
    @username = User.find(:all, :select => "username")
    
    
    
  end

end
