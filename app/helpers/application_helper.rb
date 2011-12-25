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
      
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
  
  def rank_convert(rank)
    if not rank
      return -31
    end
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
      return newrank
    else
      puts "I DID NOT KNOW WHAT TO DO."
      return -31
    end
  end
    
  def scrape
    
    kgsnames = User.select("kgs_names")
    
    for x in kgsnames
      if not x.kgs_names
        next
      end
      puts "Scraping #{x.kgs_names}..."
      match_scraper(x.kgs_names)
      sleep(2)
    end
    # match_scraper('LonelyJoy')
    # match_scraper('thesirjay')
  
  end

  def processRow(row)
    # This next line gets the 1st <a> tag in the first <td> tag (which is our sgf link), or nil if it's a private game.
    
    url = row.at('a')[:href]
    columns = row.css('td')
    
    i = 0

    public_game = columns[i].content
    i += 1
    
    if (columns[4].content != "Review") and (columns[5].content == "Unfinished")
      
       # Unfinished games
      
       puts "Game discarded because it was unfinished"
       return false
       
    end
    
    if columns[4].content == "Review"
      
      # Review games
      
      myRegex =  /(\w+) \[(\?|-|\w+)\??\]/
      
      white_black_array = columns[i].content.scan(myRegex)
      
      if (not white_black_array[0]) or (not white_black_array[1]) or (not white_black_array[2])
        puts "Game discarded due to closed or banned KGS account"
        return false
      end
      
      # Check for rank drift and remove duplicates of the reviewer's name
      if white_black_array[0][0] == white_black_array[1][0]
        white_black_array.delete_at(1)
      elsif white_black_array[0][0] == white_black_array[2][0]
        white_black_array.delete_at(2)
      else
        puts "Game discarded, reviewed by someone else"
        return false
      end
    
      i += 1

      # Calculate black player name and rank - Note that black will ALWAYS be our reviewer for our purposes
      black_player_name = white_black_array[0][0]
      black_player_rank = rank_convert(white_black_array[0][1])
      
      # Calculate white player name and rank - Note that white will ALWAYS be our reviewee
      white_player_name = white_black_array[1][0]
      white_player_rank = rank_convert(white_black_array[1][1])

    elsif columns[4].content == "Demonstration"

      # Demonstration games
      
      myRegex =  /(\w+) \[(\?|-|\w+)\??\]/
      
      rank_array = columns[i].content.scan(myRegex)[0]
      i += 1

      # Calculate black player name and rank - Note that black will ALWAYS be our demoer
      black_player_name = rank_array[0]
      black_player_rank = rank_convert(rank_array[1])

      # THERE IS NO WHITE
      white_player_name = "None"
      white_player_rank = -31

    else

      myRegex =  /(\w+) \[(\?|-|\w+)\??\]/

      rank_array = columns[i].content.scan(myRegex)[0]
      i += 1
      rank_arrayb = columns[i].content.scan(myRegex)[0]
      i += 1

      if not rank_array
        puts "Game discarded due to closed or banned KGS account"
        return false
      end

      if not rank_arrayb
        puts "Game discarded due to closed or banned KGS account"
        return false
      end

      # Calculate white player name and rank
      white_player_name = rank_array[0]
      white_player_rank = rank_convert(rank_array[1])

      # Calculate black player name and rank
      black_player_name = rank_arrayb[0]
      black_player_rank = rank_convert(rank_arrayb[1])
      
    end


    if not User.find_by_kgs_names(black_player_name)
      puts "Game discarded due to non-ASR member"
      return false 
    end

    if not User.find_by_kgs_names(white_player_name)
      puts "Game discarded due to non-ASR member"
      return false 
    end
    
    # Check both users are in the same division
    if not User.find_by_kgs_names(black_player_name).division == User.find_by_kgs_names(white_player_name).division
      puts "Game discarded due to members being in different pools"
      return false 
    end
    


    # Parse board size
    board_size_and_handicap = columns[i].content
    boardArray = columns[i].content.scan(/[0-9]+/)
    board_size = Integer(boardArray[0])
    i += 1
  
    if boardArray.length() == 3
      handi = Integer(boardArray[2])
    else
      handi = Integer(0)
    end
    
    # Calculate UNIX time
    date = columns[i].content
    i += 1
    unixtime = DateTime.strptime(date, "%m/%d/%Y %I:%M %p").utc.to_time.to_i * -1
    
    game_type = columns[i].content
    i += 1
    
    # Parse game results
    result = columns[i].content
    i += 1

    resArray = result.split('+')
    score = 0
    if resArray[0] == ("W")
      result_boolean = true
    else
      result_boolean = false
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
  
    return {"url" => url, "white_player_name" => white_player_name, "white_player_rank" => white_player_rank, "black_player_name" => black_player_name, "black_player_rank" => black_player_rank, "result_boolean" => result_boolean, "score" => score, "board_size" => board_size, "handi" => handi, "unixtime" => unixtime, "game_type" => game_type, "public_game" => public_game, "result" =>result}
  end

  def sgfParser(url)
    # SGF Parser
    
    require 'net/http'
    require 'open-uri'
    require 'sgf'
    sgf_raw = open(url).read
    parser = SGF::Parser.new 
    tree = parser.parse sgf_raw
    
    game_info = tree.root.children[0].properties
    valid_sgf = true
    invalid_reason = []

    # Confirm 'ASR League' is mentioned within first 30 moves
    game = tree.root
    found = false

    count = 0
    tree.each { |node| count += 1 }

    if count > 30
      for i in 0..30

        comment = game.comments
        if comment
          if comment.scan(/ASR League/i)
            found = true
          end
        end

        game = game.children[0]
      end
    end
    
    if found != true
      valid_sgf = false
      invalid_reason << "did not contain tag line"
    end

    # Check that over time is at least 5x30 byo-yomi
    over_time = game_info["OT"]
    if over_time == nil
      valid_sgf = false
      invalid_reason << "over_time was nil"
    end
    
    # Restrict overtime settings
    over_time = over_time.split(' ')
    byo_yomi_periods = over_time[0].split('x')[0].to_i # Parse SGF overtime periods
    byo_yomi_seconds = over_time[0].split('x')[1].to_i # Parse SGF overtime seconds

    if (byo_yomi_periods < 5) and (byo_yomi_seconds < 30)
      valid_sgf = false
      invalid_reason << "incorrect byo-yomi: #{byo_yomi_periods}x#{byo_yomi_seconds}"
    end
    
    # Check main time is not less than 1500
    main_time = game_info["TM"].to_i
    
    if main_time < 1500
      valid_sgf = false
      invalid_reason << "incorrect main time: #{main_time}"
    end        
    
    # Check ruleset is Japanese
    ruleset = game_info["RU"]
    
    if ruleset != "Japanese"
      valid_sgf = false
      invalid_reason << "incorrect ruleset: #{ruleset}"
    end

    # Add byo-yomi settings
    ruleset = over_time[1]
    
    # Check komi is 6.5 or 0.5
    komi = game_info["KM"].to_f
    
    unless komi == 6.5
      valid_sgf = false
      invalid_reason << "incorrect komi: #{komi}"
    end
    
    return [byo_yomi_periods, byo_yomi_seconds, main_time, ruleset, komi, valid_sgf, invalid_reason]
  end

  def match_scraper(kgs_name)

    
    require 'open-uri'
    require 'time'

    doc = Nokogiri::HTML(open("http://www.gokgs.com/gameArchives.jsp?user=#{kgs_name}"))

    # Check that page contains at least one game record
    if doc.css("h2").inner_html.include? '(0 games)'
      puts "#{kgs_name} hasn't played any games at all this month"
      return
    end
    
    puts doc.css("h2").inner_html

    doc = doc.xpath('//table[1]')
    doc = doc.css('tr:not(:first)')
    
    games = []
    
    doc.reverse_each do |row|
      rowResult = processRow(row)
      if rowResult != false
        games << rowResult
      end
    end

    return if games.length() == 0

    # Update ranking for this user
    user = User.find_by_kgs_names(kgs_name)
    
    if games[0]["white_player_name"] == kgs_name
      user.rank = games[0]["white_player_rank"]
      user.save
    elsif games[0]["black_player_name"] == kgs_name
      user.rank = games[0]["black_player_rank"]
      user.save
    end
    
    # Various filters
    for row in games
      valid_game = true
      invalid_reason = []
      parsedurl = row["url"]

      # KGS Archive parsing discard reasons
      if row["public_game"] == "No"
        puts "Game discarded due to being private"
        next
      end

      if Match.find_by_url(parsedurl)
        puts "Game already in Database"
        next
      end

      if row["board_size"] != 19
        invalid_reason << "incorrect board size"
        valid_game = false
      end

      if row["game_type"] == "Rengo"
        invalid_reason << "was a rengo game"
        valid_game = false
      end

      if row["game_type"] == "Teaching"
        invalid_reason << "was a teaching game"
        valid_game = false
      end
      
      if row["game_type"] == "Review"
        invalid_reason << "review game"
        valid_game = false
      end

      if row["handi"] != 0
        invalid_reason << "incorrect handicap"
        valid_game = false
      end

      # That's all we can get from the KGS Archives, now to check the SGF
      sgf = sgfParser(row["url"])
      
      if sgf[3] == "Canadian"
        puts "Game discarded because Andrew hates Canadians"
        next
      end

      if sgf[5] == false
        valid_game = false
        for x in sgf[6]
          invalid_reason << x
        end
      end
      
      player1 = row["black_player_name"]
      player2 = row["white_player_name"]
      
      whereResult = Match.where('(black_player_name=? OR white_player_name=?) AND (black_player_name=? OR white_player_name=?)', player1, player1, player2, player2)

      matchnum = 2 - whereResult.length
      matchnum = 0 if matchnum < 0
      
      if whereResult.length >= 2
        valid_game = false
        invalid_reason << "third or higher game against same opponent"
      end
      
      # Points attribution
      if valid_game == true
        if row["result_boolean"] == false
          winner = User.find_by_kgs_names(row["black_player_name"])
          loser = User.find_by_kgs_names(row["white_player_name"])
        else
          winner = User.find_by_kgs_names(row["white_player_name"])
          loser = User.find_by_kgs_names(row["black_player_name"])
        end   

        if winner.points.nil?
          winner.points = 0
        end
        if loser.points.nil?
          loser.points = 0
        end

        winner.points += 1 * matchnum
        loser.points += 0.5 * matchnum

        puts "#{winner.kgs_names} +#{1 * matchnum}"
        puts "#{loser.kgs_names} +#{0.5 * matchnum}"

        winner.save
        loser.save
      end

      # Everything is green, submit game to DB
      puts "Game added to db as #{valid_game}: #{invalid_reason.join(", ").capitalize}"
      rowadd = Match.new(:url => row["url"], :white_player_name => row["white_player_name"],
                                             :white_player_rank => row["white_player_rank"],
                                             :black_player_name => row["black_player_name"], 
                                             :black_player_rank => row["black_player_rank"], 
                                             :result_boolean => row["result_boolean"], 
                                             :score => row["score"], 
                                             :board_size => row["board_size"], 
                                             :handi => row["handi"], 
                                             :unixtime => row["unixtime"], 
                                             :game_type => row["game_type"], 
                                             :ruleset => sgf[3], 
                                             :komi => sgf[4],
                                             :result => row["result"],
                                             :main_time => sgf[2],
                                             :byo_yomi_periods => sgf[0], 
                                             :byo_yomi_seconds => sgf[1],
                                             :invalid_reason => invalid_reason.join(", ").capitalize,
                                             :valid_game => valid_game)
      rowadd.save

    end # End for loop
   
   end
   
   def rank_to_string(rank)
         
     if rank > 0
         return "#{rank} dan"
     elsif rank == -31
         return "-"
     else
       return "#{(rank - 1).abs} kyu"
     end    
              
   end
   
end
