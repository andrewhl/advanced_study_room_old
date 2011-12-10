class MatchesController < ApplicationController

  def manage
    @division = User.division
    redirect_to manage_path
  end
  
  def add_to_division
    
  end
  
  def add_to_waiting_list
    
  end

end
