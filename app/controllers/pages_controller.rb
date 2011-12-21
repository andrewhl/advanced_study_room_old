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
    @delta = User.where(:division => "Delta").order(sort_column + ' ' + sort_direction)
    @delta.each do |player|
      white_wins = Match.where("white_player_name=? AND result_boolean=true AND valid_game=true", player.kgs_names).length
      black_wins = Match.where("black_player_name=? AND result_boolean=false AND valid_game=true", player.kgs_names).length
      @wins = white_wins + black_wins
      @total_games = Match.where("(white_player_name=? OR black_player_name=?) AND valid_game=true", player.kgs_names).length
      @losses = total_games - wins
    end
      
    @title = "Results"
    divisions = ["Alpha", "Beta I", "Beta II", "Gamma I", "Gamma II", "Gamma III", "Gamma IV", "Delta"]
    @division_players = User.where(:division => divisions)
    
    @games = Match.all
    
    # @delta = User.where(:division => "Delta")
    

    
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
