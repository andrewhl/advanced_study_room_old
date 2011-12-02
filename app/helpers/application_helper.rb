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
          if item[0,2] == "19" then         
            url_data << 19
          else
            url_data << item
          end           
       end
       puts newvar
    end
    url_data.each do |output|
        print output
    end
    return result
    
  end
  
  def nokogiri_get 
    
    require 'open-uri'
    doc = Nokogiri::HTML(open("http://www.gokgs.com/gameArchives.jsp?user=andrew&year=2011&month=11"))
    doc = doc.xpath('//table[1]')
    viewable = doc.css('tr > td[1]').each do |stuff|
      puts stuff.content
    end
    white_player = doc.css('tr > td[2] > a').each do |stuff|
      puts stuff.content
    end
    black_player = doc.css('tr > td[3] > a').each do |stuff|
      puts stuff.content
    end
    board_size_and_handicap = doc.css('tr > td[4]').each do |stuff|
      puts stuff.content
    end
    date = doc.css('tr > td[5]').each do |stuff|
      puts stuff.content
    end
    game_type = doc.css('tr > td[6]').each do |stuff|
      puts stuff.content
    end
    result = doc.css('tr > td[7]').each do |stuff|
      puts stuff.content
    end
    
    #return white_player_contents
    
    # doc.css('tr td').each do |node|
    #       puts node.text
    #     end
    #     #return doc
  end
end
