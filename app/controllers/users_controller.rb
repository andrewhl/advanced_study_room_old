class UsersController < ApplicationController
  def index  
    @users = User.all     
    @username = User.find_all_by(username)
  end

  def manage
    @user = User.find_all_by_kgs_names
    #@division = User.find_all_by_division
    redirect_to manage_path
  end
  
  def add_to_division
    
  end
  
  def add_to_waiting_list
    
  end

end
