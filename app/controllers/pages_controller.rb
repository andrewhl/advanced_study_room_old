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
  end

  def prizes
    @title = "Prizes"
  end

  def news
    @title = "News"
  end

end
