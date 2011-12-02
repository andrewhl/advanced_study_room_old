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
    print "FUCK"
    result.each do |var|
       var = var.slice(4..-6)
       newvar = var.split('</td><td>', -1)
       for item in newvar
       	  thing = item[0,2]
          if item[0,2] == "19" then             
            url_data << 19
            if item[-2,1] == "H" then
            	url_data << Integer(item[-1,1])
            else
            	url_data << 0
            end
          else
            url_data << item
          end           
       end
    end
#    url_data.each do |output|
#        print output
#    end
#   return result
    
  end
end
