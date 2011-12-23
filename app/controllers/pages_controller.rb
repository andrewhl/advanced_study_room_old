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
    
    params[:sort] ||= "points"
    params[:direction] ||= "desc"
  
    if params[:sort] == ("username" or "points")
      delta = User.where(:division => "Delta").order(sort_column + ' ' + sort_direction)
    else
      delta = User.where(:division => "Delta")
    end

    @deltaArr = []
    delta.each do |player|
      white_wins = Match.where("white_player_name=? AND result_boolean=? AND valid_game=?", player.kgs_names, true, true).length
      black_wins = Match.where("black_player_name=? AND result_boolean=? AND valid_game=?", player.kgs_names, false, true).length
      wins = white_wins + black_wins
      total_games = Match.where("(white_player_name=? OR black_player_name=?) AND valid_game=?", player.kgs_names, player.kgs_names, true).length
      losses = total_games - wins
      @deltaArr << [player.kgs_names, player.points, total_games, wins, losses]
    end

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

