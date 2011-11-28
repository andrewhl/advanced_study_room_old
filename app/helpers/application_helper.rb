module ApplicationHelper
  
  def title 
    base_title = "Advanced Study Room"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def sub_title
    "#{@title}"
  end
end
