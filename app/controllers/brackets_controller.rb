include SuffixGenerator
include NameGenerator

class BracketsController < ApplicationController
  before_filter :find_division, :only => [:new, :create]
  before_filter :find_bracket, :only => [:show, :destroy]

  def new
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
    
    @bracket = Bracket.create(params[:bracket])
    @bracket.division_id = params[:division_id]
    @bracket.save
    puts params.inspect
    flash[:success] = "#{@bracket.name} created"
    if params[:commit]
      redirect_to brackets_path
    end
    # render :index
  end
  
  def destroy
    @bracket.destroy
    flash[:success] = "#{@bracket.name} successfully removed"
    
    respond_to do |format|  
      format.html { redirect_to :action => 'index' }  
      format.js   { render :nothing => true }  
    end
    
  end
  
  def show
    
  end
  
  protected
    def find_division
      @division = Division.find(params[:division_id])
    end
    
    def find_bracket
      @bracket = Bracket.find(params[:id])
    end
  
end
