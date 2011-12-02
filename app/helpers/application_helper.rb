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
    #require 'net/http'
    #result = Net::HTTP.get(URI.parse('http://www.gokgs.com/gameArchives.jsp?user=andrew&year=2011&month=11'))
    
    #require 'open-uri'
    #doc = Nokogiri::HTML(open("http://www.gokgs.com/gameArchives.jsp?user=andrew&year=2011&month=11"))  
    result = open('public/url_get.txt').read
    #result.slice!(result.index('!DOCTYPE'), result.index('<tr>'))
    result = result.slice!(result.index('<tr>')..-1)
    result.slice!(result.index('</table>')..-1)
    result.slice!(result.index('<tr>'), result.rindex('</th>') + 10)
    result = result.split('</tr><tr>', -1)
    url_data = []
    result.each do |var|
       var = var.slice(4..-6)
       newvar = var.split('</td><td>', -1)
       newvar.each do |item|
          if item.slice(0,4) == "19x19" then 
            board_size = item.gsub("19x19", "19") 
            url_data << board_size
          else
            url_data << item
          end           
       end
       puts newvar
    end
    url_data.each do |output|
        print output
    end
   #return result
    
  end
end
