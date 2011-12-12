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
    # To do: create an array and fill it with all the divisions, and then drop that into a query that iterates through each division in the array
    @unassigned = User.where("division is NULL OR division = 'Waiting List'")
    @alpha = User.where(:division => "Alpha")
    @betaI = User.where(:division => "Beta I")
    @betaII = User.where(:division => "Beta II")
    @gammaI = User.where(:division => "Gamma I")
    @gammaII = User.where(:division => "Gamma II")
    @gammaIII = User.where(:division => "Gamma III")
    @gammaIV = User.where(:division => "Gamma IV")
    @delta = User.where(:division => "Delta")
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