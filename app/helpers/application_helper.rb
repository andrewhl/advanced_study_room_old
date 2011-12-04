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
    
  def nokogiri_get 
    
    require 'open-uri'
    require 'time'
    doc = Nokogiri::HTML(open("http://www.gokgs.com/gameArchives.jsp?user=andrew&year=2011&month=11"))
    doc = doc.xpath('//table[1]')
    links = doc.css('tr > td[1] > a').map { |link| link[:href] }
    puts links
    white_player = doc.css('tr > td[2] > a').each do |stuff|
      white_player_name = stuff.content.scan(/^\w+/)
      white_player_rank = stuff.content.scan(/\?|-|[1-9]?[1-9][kdp]/) # Regex for KGS ranks
      test2 = rank_convert(white_player_rank)
      puts test2
      puts "#{white_player_name}, #{white_player_rank}"
    end
    black_player = doc.css('tr > td[3] > a').each do |stuff|
      black_player_name = stuff.content.scan(/^\w+/)
      black_player_rank = stuff.content.scan(/\?|-|[1-9]?[1-9][kdp]/) # Regex for KGS ranks
      test = rank_convert(black_player_rank)
      puts test
      puts "#{black_player_name}, #{black_player_rank}"
    end
    board_size_and_handicap = doc.css('tr > td[4]').each do |stuff|
      boardArray = stuff.content.scan(/[0-9]+/)
      board_size = boardArray[0]
	  
	  if boardArray.length() == 3
	    handi = boardArray[2]
	  else
	    handi = 0
	  end
	  print "Board Size: ", board_size, "\n"
	  print "Handicap: ", handi, "\n"
	  
    end
    date = doc.css('tr > td[5]').each do |stuff|
      stuff = stuff.content
      time = DateTime.strptime(stuff, "%m/%d/%Y %I:%M %p").utc.to_time.to_i * -1
      puts time
    end
    game_type = doc.css('tr > td[6]').each do |stuff|
      unless stuff.content.include?("Rengo")
        puts stuff.content
      end
    end
    result = doc.css('tr > td[7]').each do |stuff|
      puts stuff.content
    end

  end
  
  def rank_convert(rank)
    rank = rank[0]
    if rank[-1,1] == "d"
      newrank = rank.scan(/[1-9]/)[0]
      newrank = Integer(newrank)
      rank_boolean = true
      return newrank
    elsif rank[-1,1] == "k"
      newrank = rank.scan(/[1-9]/)[0]
      newrank = Integer(newrank) * -1 + 1
      rank_boolean = true
      return newrank
    elsif (rank == "?") or (rank == "-")
      newrank = -31
      rank_boolean = false
    else
      puts "I DID NOT KNOW WHAT TO DO."
    end
  end
  
  def nokogiri_test
    
    require 'open-uri'
    require 'time'
    doc = Nokogiri::HTML(open("http://www.gokgs.com/gameArchives.jsp?user=andrew&year=2011&month=11"))
    doc = doc.xpath('//table[1]')
    doc = doc.css('tr:not(:first)')
    
    games = []
    
    # prints them out, row by row.
    doc.each do |row|
      # This next line gets the 1st <a> tag in the first <td> tag (which is our sgf link), or nil if it's a private game.
      puts url = row.at('a')[:href]
      columns = row.css('td')
      private_game = columns[0].content
      
      # Calculate white player name and rank
      white_player_name = columns[1].content.scan(/^\w+/)
      white_player_rank = columns[1].content.scan(/\?|-|[1-9]?[1-9][kdp]/)
      white_player_rank = rank_convert(white_player_rank)
      
      # Calculate black player name and rank
      black_player_name = columns[2].content.scan(/^\w+/)
      black_player_rank = columns[2].content.scan(/\?|-|[1-9]?[1-9][kdp]/)
      black_player_rank = rank_convert(black_player_rank)
      
      # Parse board size
      board_size_and_handicap = columns[3].content
      boardArray = columns[3].content.scan(/[0-9]+/)
      board_size = boardArray[0]
	  
  	  if boardArray.length() == 3
  	    handi = boardArray[2]
  	  else
  	    handi = 0
  	  end
  	  #print "Board Size: ", board_size, "\n"
  	  #print "Handicap: ", handi, "\n"

      # Calculate UNIX time
      date = columns[4].content
      unixtime = DateTime.strptime(date, "%m/%d/%Y %I:%M %p").utc.to_time.to_i * -1
      
      game_type = columns[5].content
      result = columns[6].content
      resArray = result.split('+')
      score = 0
      if resArray[0] == ("W")
        white_win = true
        black_win = false
      else
        white_win = false
        black_win = true
      end
      if resArray[1] == "Res." 
        score = -1.0
      elsif resArray[1] == "Forf." 
        score = -2.0
      elsif resArray[1] == "Time" 
        score = -3.0
      elsif resArray[1] == nil
        score = 0
      else 
          score = Float(resArray[1])
      end 
      
      games << {"url" => url, "white_player_name" => white_player_name, "white_player_rank" => white_player_rank, "black_player_name" => black_player_name, "black_player_rank" => black_player_rank, "board_size" => board_size, "handi" => handi, "unixtime" => unixtime, "game_type" => game_type, "result" =>result}
      #puts "White name: #{white_player_name}", "White rank: #{white_player_rank}", "Black name: #{black_player_name}", "Black rank: #{black_player_rank}", "UNIX time: #{unixtime}", "Game type: #{game_type}", "Result: #{result}"
      #games << url, white_player_name, white_player_rank, black_player_name, black_player_rank, unixtime, game_type, result
      
      # for text in row.css('td')
      #         # prints the content for each <td> in the row.
      #         if text.scan()
      #         puts text.content
      #       end
    end
    puts games
    return resArray
    
  end
  
end
