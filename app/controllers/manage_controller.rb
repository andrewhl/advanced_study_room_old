class ManageController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    params[:sort] ||= "kgs_names"
    @user = User.order(sort_column + ' ' + sort_direction)
  end
  
  def show
  end
  
  def new
  end
  
  def create
  end
  
  def edit
  end
  
  def update
    @user = User.all
    if params[:kgs_names] != nil
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
  
  def destroy
  end
  
  private
  
  def sort_column
   User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end