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
  
  def url_get  
    require 'net/http'
    result = Net::HTTP.get(URI.parse('http://www.gokgs.com/gameArchives.jsp?user=andrew'))
    return result
    
  end
end
