class UsersController < ApplicationController
  def index  
  end
  
  def add_to_division
    
  end
  
  def add_to_waiting_list
    
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def update_kgs_names
   @user = User.find params[:id]
   if @user.update_attributes(params[:kgs_names])
    render :text => "Success"
   else
    render :text => "Error", :status => 500
   end
  end

end
