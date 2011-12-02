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
    
    # When item is the handicap field....
      
    result.each do |var|
       var = var.slice(4..-6)
       newvar = var.split('</td><td>', -1)
       newvar.each do |item|
          if item[0,2] == "19" then         
            url_data << 19
            if item [-2,1] == "H" then
              url_data << Integer(item[-1,1])
            else
              url_data << 0
            end
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
    require 'time'
    doc = Nokogiri::HTML(open("http://www.gokgs.com/gameArchives.jsp?user=andrew&year=2011&month=11"))
    doc = doc.xpath('//table[1]')
    viewable = doc.css('tr > td[1] > a').each do |stuff|
      puts stuff
    end
    white_player = doc.css('tr > td[2] > a').each do |stuff|
      white_player_name = stuff.content.scan(/^\w+/)
      white_player_rank = stuff.content.scan(/\?|-|[1-9]?[1-9][kdp]\W/) # Regex for KGS ranks
      test2 = rank_convert(white_player_rank)
      puts test2
      puts "#{white_player_name}, #{white_player_rank}"
    end
    black_player = doc.css('tr > td[3] > a').each do |stuff|
      black_player_name = stuff.content.scan(/^\w+/)
      black_player_rank = stuff.content.scan(/\?|-|[1-9]?[1-9][kdp]\W/) # Regex for KGS ranks
      test = rank_convert(black_player_rank)
      puts test
      puts "#{black_player_name}, #{black_player_rank}"
    end
    board_size_and_handicap = doc.css('tr > td[4]').each do |stuff|
      if stuff.grep(/19/)
        board_size = 19
        puts board_size
      else
        board_size = "Invalid"
        puts board_size
      end
      off_board_sizes = ["9\u00d79", "13\u00d713", "15\u00d715", "17\u00d717", "21\u00d721"] # Unicode multiplication symbol, for unauthorized board sizes
      unless stuff.content.slice(0,3).include?("9\u00d79")
        puts stuff.content.slice(0,5)
      end
    end
    date = doc.css('tr > td[5]').each do |stuff|
      puts stuff.content
      
    end
    game_type = doc.css('tr > td[6]').each do |stuff|
      unless stuff.content.include?("Rengo")
        puts stuff.content
      end
    end
    result = doc.css('tr > td[7]').each do |stuff|
      puts stuff.content
    end
    return viewable
    
    #return white_player_contents
    
    # doc.css('tr td').each do |node|
    #       puts node.text
    #     end
    #     #return doc
  end
  
  def rank_convert(rank)
    
    if (rank.grep(/d/))
      newrank = rank.grep(/[1-9]/,&:to_i)
      return newrank
    elsif (rank.grep(/k/))
      newrank = rank.grep(/[1-9]?[0-9]/,&:to_i).negative
      return newrank
    elsif (rank.grep(/-|\?/))
      newrank.to_i = 0
      return newrank
    end
      
  end
end
