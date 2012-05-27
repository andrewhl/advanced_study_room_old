include SuffixGenerator
include NameGenerator

class BracketsController < ApplicationController

  def new
    @division = Division.find(params[:division_id])
    @bracket = Bracket.new :division_id => params[:division_id] # @division.brackets.build
    # @bracket = @division.brackets.build
  end

  def index
    if !user_signed_in?
      redirect_to :root
      flash[:notice] = "Sorry, you must be signed in to view that page."
    end
    
    @divisions = Division.all
    
    @brackets = Bracket.all
    @bracket = Bracket.new
    # redirect_to :action => "create"
  end
  
  def create
    
    @division = Division.find(params[:division_id])
    @bracket = Bracket.create(params[:bracket])
    flash[:success] = "#{@bracket.name} created"
    if params[:commit]
      redirect_to @division
    end
    # render :index
  end
  
  def destroy
    @bracket = Bracket.find(params[:id])
    @bracket.destroy
    flash[:success] = "#{@bracket.name} successfully removed"
    
    respond_to do |format|  
      format.html { redirect_to :action => 'index' }  
      format.js   { render :nothing => true }  
    end
    
  end
  
end
