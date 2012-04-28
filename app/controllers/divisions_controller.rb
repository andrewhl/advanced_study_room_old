include SuffixGenerator
include NameGenerator

class DivisionsController < ApplicationController

  def index
    @divisions = Division.all
    @division = Division.new
    
  end
  
  def update
    @division = Division.find(params[:id])
    @division.update_attributes(params[:division])
    redirect_to :action => 'index'
    flash[:success] = "Division updated"
  end

  def create
    @division = Division.create(params[:division])
    if params[:submit]
      redirect_to :action => 'index'
    end
    # render :index
  end

  def destroy
    @division = Division.find(params[:id])
    @division.destroy
    
    respond_to do |format|  
      format.html { redirect_to :action => 'index' }  
      format.js   { render :nothing => true }  
    end
    
  end
  
  def division_form
    @division = Division.new(params[:division])
    @division.save
    
    render :partial => "division"
  end
  
end
