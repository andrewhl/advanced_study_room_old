class PagesController < ApplicationController
  helper_method :sort_column, :sort_direction
  def home
    @title = "Home"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def league
    @title = "League"
  end

  def results
    
    # Default values for the page sorting.
    params[:sort] ||= "points"
    params[:direction] ||= "desc"
  
    # Checks to see if we're sorting by a user column. If we are, it uses SQL's sort (.order) because it's faster than ruby's array.sort
    # If you didn't want to hardcode the values, you could rewrite this to do a dynamic check to see if the column name exists in the model.
    # But currently it's hardcoded for conveinance.
    if params[:sort] == ("username" or "points")
      delta = User.where(:division => "Delta").order(sort_column + ' ' + sort_direction)
    else
      delta = User.where(:division => "Delta")
    end

    # We're gonna loop through all the users now, and put the information we want into @deltaArr so we can access it on the page
    @deltaArr = []
    delta.each do |player|
      
      # Calculates all our dynamic shit
      white_wins = Match.where("white_player_name=? AND result_boolean=? AND valid_game=?", player.kgs_names, true, true).length
      black_wins = Match.where("black_player_name=? AND result_boolean=? AND valid_game=?", player.kgs_names, false, true).length
      wins = white_wins + black_wins
      total_games = Match.where("(white_player_name=? OR black_player_name=?) AND valid_game=?", player.kgs_names, player.kgs_names, true).length
      losses = total_games - wins

      # Puts all our shit into @deltaArr
      @deltaArr << [player.kgs_names, player.points, total_games, wins, losses]
    end

    # A big statment checking for hardcoded column names. No way around this, unless you use numbers
    # to link your columns - but then that would break SQL ordering, which we wanted to keep.
    #
    # Once it finds the right column, it checks if we're sorting by asc or desc, then uses a .sort code block
    # to sort either by ascending or descending (just swaps x/y positions). The slice is the index we added to @deltaArr
    if params[:sort] == "matches played"
      if params[:direction] == "desc"
        @deltaArr.sort! {|x,y| y[2] <=> x[2]}
      else
        @deltaArr.sort! {|x,y| x[2] <=> y[2]}
      end
    elsif params[:sort] == "wins"
      if params[:direction] == "desc"
        @deltaArr.sort! {|x,y| y[3] <=> x[3]}
      else
        @deltaArr.sort! {|x,y| x[3] <=> y[3]}
      end
    elsif params[:sort] == "losses"
      if params[:direction] == "desc"
        @deltaArr.sort! {|x,y| y[4] <=> x[4]}
      else
        @deltaArr.sort! {|x,y| x[4] <=> y[4]}
      end
    end

    # Other misc shit
    @title = "Results"
    divisions = ["Alpha", "Beta I", "Beta II", "Gamma I", "Gamma II", "Gamma III", "Gamma IV", "Delta"]
    @division_players = User.where(:division => divisions)
        
  end

  def prizes
    @title = "Prizes"
  end

  def news
    @title = "News"
  end

  private
  
  def sort_column
   User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end

