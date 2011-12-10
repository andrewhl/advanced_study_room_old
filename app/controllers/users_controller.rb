class UsersController < ApplicationController
  def index  
    @users = User.all     
    @username = User.find_all_by(username)
  end

  def manage
    @user = User.find_all_by_kgs_names
    @division = User.first
    #redirect_to manage_path
  end
  
  def manage_users
    @user = User.find_all_by_kgs_names
    @division = User.first
    #redirect_to manage_path
  end
  
  def add_to_division
    
  end
  
  def add_to_waiting_list
    
  end
  
  def test
    @user = User.find_all_by_kgs_names
    @test = User.where(params[:kgs_names]).inspect  
  end

end
