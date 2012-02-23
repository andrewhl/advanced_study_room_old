include SuffixGenerator
include NameGenerator

class DivisionsController < ApplicationController
  def index
    
    if Division.count == 0 
      @division = Division.create(:division_name => "Alpha",
                                         :bracket_suffix => "I",
                                         :bracket_players_min => 10,
                                         :bracket_players_max => 25,
                                         :bracket_number => 1,
                                         :division_players_min => 10,
                                         :division_players_max => 25,
                                         :min_points_required => 15,
                                         :min_games_required => 4,
                                         :min_wins_required => 1,
                                         :max_losses_required => 4,
                                         :immunity_boolean => false,
                                         :demotion_buffer => 4,
                                         :promotion_buffer => 1,
                                         :division_hierarchy => 1)
    end
    
    @divisions = Division.all
    @division = Division.new(params[:division])
    @division.save
    
  end

  def create
    @division = Division.new(params[:division]) # (params[:post])

    if @division.save
      if request.xhr?
        render @division
      else
        flash[:notice] = "Division added"
        render :index
      end
    else
      if request.xhr?
        render :status => 403
      else
        flash[:error] = "Division could not be added."
        render :index
      end
    end
  end

  def update
  end

  def edit
  end

  def destroy
    @division = Division.find(params[:id])
    @division.destroy
    
    render :index
    
  end
  
  def divisions
    
    if Division.count == 0 
      @division = Division.create(:division_name => "Alpha",
                                         :bracket_suffix => "I",
                                         :bracket_players_min => 10,
                                         :bracket_players_max => 25,
                                         :bracket_number => 1,
                                         :division_players_min => 10,
                                         :division_players_max => 25,
                                         :min_points_required => 15,
                                         :min_games_required => 4,
                                         :min_wins_required => 1,
                                         :max_losses_required => 4,
                                         :immunity_boolean => false,
                                         :demotion_buffer => 4,
                                         :promotion_buffer => 1,
                                         :division_hierarchy => 1)
    end
    
    # if params[:commit]
    #   @new_division = Divisions.new
    #   @new_division.save
    #   render :partial => "division"
    # end
    
    @divisions = Division.all
    @division = Division.new(params[:division])
    @division.save
    
    # respond_to do |format|
    #   format.html
    #   format.js
    # end
    # @rule = Rules.last
    # @divisions_number = Rules.last.number_of_divisions
    # @suffix = makeSuffix(@divisions_number, "Roman Numerals")
    # @division_names = createNames(@divisions_number, "Greek")
  end

end
