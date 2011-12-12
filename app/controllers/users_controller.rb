class UsersController < ApplicationController
  def index  
  end
  
  def add_to_division
    
  end
  
  def add_to_waiting_list
    
  end
  
  def test
    @user = User.select(:kgs_names)
    new_division = params[:division]
    kgs_names = params[:kgs_names]
    
    for x in kgs_names
      user = User.where(:kgs_names => x)
      user.each do |y|
        y.division = new_division
        y.save
      end
    end 
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
