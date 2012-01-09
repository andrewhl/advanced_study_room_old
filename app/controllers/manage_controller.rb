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
  
  def rules
    
    # Set the defaults if no rules have been set.
    if Rules.count == 0
      @rules = Rules.new(:board_size_boolean => true, :division_boolean => true, :time_system => "Byo-Yomi", :canadian_stones => 25, :canadian_time => 300, :max_games => 2, :points_per_win => 1, :points_per_loss => 0.5, :main_time => 1500, :main_time_boolean => true, :tag_phrase => "ASR League", :board_size => "19", :month => "January", :handicap => "0", :handicap_boolean => false, :ruleset => "Japanese", :ruleset_boolean => true, :komi => 6.5, :komi_boolean => true, :tag_pos => 30, :tag_boolean => true, :ot_boolean => true, :byo_yomi_periods => 5, :byo_yomi_seconds => 25, :rengo => false, :teaching => false, :review => false, :free => true, :rated => true, :demonstration => false, :unfinished => false) 
      @rules.save
    end
    
    # Handle the rules form.
    if params[:commit]
    
      @rules = Rules.new
        
      params.each do |key, value|
        if value == "true"
          @rules[key] = true
        elsif value == "false"
          @rules[key] = false
        elsif (not value.nil?) and (not value.class == Array)
          @rules[key] = value
        elsif (not value.nil?) and (value.class == Array)
          @rules[key] = value.join(',')
          puts value
        end
      end
      @rules.save
    
    end
    
    @current_ruleset = Rules.last
          
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