class PagesController < ApplicationController
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
    @title = "Results"
    divisions = ["Alpha", "Beta I", "Beta II", "Gamma I", "Gamma II", "Gamma III", "Gamma IV", "Delta"]
    @division_players = User.where(:division => divisions)
    
    @games = Match.all
    
    @delta = User.where(:division => "Delta")
    

    
  end

  def prizes
    @title = "Prizes"
  end

  def news
    @title = "News"
  end

end
