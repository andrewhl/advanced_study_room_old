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
  
  def twitterized_type(type)
    case type
      when :alert
        "warning"
      when :notice
        "info"
      else
        type.to_s
    end
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
    
    @rules = Rules.last
    kgsnames = User.select("kgs_names")
    
    # for x in kgsnames
    #   if not x.kgs_names
    #     next
    #   end
    #   puts "Scraping #{x.kgs_names}..."
    #   match_scraper(x.kgs_names)
    #   sleep(2)
    # end
    # match_scraper('LonelyJoy')
    # match_scraper('thesirjay')
    match_scraper('NannyOgg')
  
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
    
    if columns[5].content != "Rengo"
      
      # Dummy values for non rengo games
      white_player_name_2 = "None"
      white_player_rank_2 = -31
      black_player_name_2 = "None"
      black_player_rank_2 = -31
    
    end
    
    if columns[4].content == "Review"
      
      # Review games
      
      myRegex =  /(\w+) \[(\?|-|\w+)\??\]/
      
      white_black_array = columns[i].content.scan(myRegex)
      
      i += 1
      
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

    elsif columns[5].content == "Rengo"
      
      # Rengo games
      
      myRegex =  /(\w+) \[(\?|-|\w+)\??\]/
      
      rank_array = columns[i].content.scan(myRegex)[0]
      rank_arrayb = columns[i].content.scan(myRegex)[1]
      
      i += 1
      
      rank_arrayc = columns[i].content.scan(myRegex)[0]
      rank_arrayd = columns[i].content.scan(myRegex)[1]
      
      i += 1
      
      if (not rank_array) or (not rank_arrayb) or (not rank_arrayc) or (not rank_arrayd)
        puts "Game discarded due to closed or banned KGS account"
        return false
      end
      
      # Calculate first white player name and rank
      white_player_name = rank_array[0]
      white_player_rank = rank_convert(rank_array[1])
      
      # Calculate second white player name and rank
      white_player_name_2 = rank_arrayb[0]
      white_player_rank_2 = rank_convert(rank_arrayb[1])

      # Calculate first black player name and rank
      black_player_name = rank_arrayc[0]
      black_player_rank = rank_convert(rank_arrayc[1])
      
      # Calculate second black player name and rank
      black_player_name_2 = rank_arrayd[0]
      black_player_rank_2 = rank_convert(rank_arrayd[1])
      
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

    if columns[5].content == "Rengo"

      if not User.find_by_kgs_names(black_player_name)
        puts "Game discarded due to non-ASR member"
        return false 
      end
      
      if not User.find_by_kgs_names(black_player_name_2)
        puts "Game discarded due to non-ASR member"
        return false 
      end

      if not User.find_by_kgs_names(white_player_name)
        puts "Game discarded due to non-ASR member"
        return false 
      end
      
      if not User.find_by_kgs_names(white_player_name_2)
        puts "Game discarded due to non-ASR member"
        return false 
      end

    else
      
      if not User.find_by_kgs_names(black_player_name)
        puts "Game discarded due to non-ASR member"
        return false 
      end

      if not User.find_by_kgs_names(white_player_name)
        puts "Game discarded due to non-ASR member"
        return false 
      end
      
    end  
    
    # Check that all users in a rengo game are in the same division
    if (columns[5].content == "Rengo") and (@rules.division_boolean == true)
      rengo_divisions = []
      rengo_divisions << User.find_by_kgs_names(black_player_name).division << User.find_by_kgs_names(black_player_name_2).division << User.find_by_kgs_names(white_player_name).division << User.find_by_kgs_names(white_player_name_2).division
      if rengo_divisions.uniq.length != 1
        puts "Game discarded due to members being in different pools"
        return false
      end
    else 
    # Check both users are in the same division
      if (not User.find_by_kgs_names(black_player_name).division == User.find_by_kgs_names(white_player_name).division) and (@rules.division_boolean == true) 
        puts "Game discarded due to members being in different pools"
        return false
      end
    end

    # Parse board size
    board_size_and_handicap = columns[i].content
    boardArray = columns[i].content.scan(/([0-9]+)/)
    board_size = Integer(boardArray[0][0])
    i += 1
  
    if boardArray.length() == 3
      handi = Integer(boardArray[2])
    else
      handi = Integer(0)
    end
    
    # Calculate UNIX time
    date = columns[i].content
    i += 1
    unixtime = DateTime.strptime(date, "%m/%d/%y %I:%M %p").utc.to_time.to_i
    
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
  
    return {"url" => url, "white_player_name" => white_player_name, "white_player_rank" => white_player_rank, "black_player_name" => black_player_name, "black_player_rank" => black_player_rank, "white_player_name_2" => white_player_name_2, "white_player_rank_2" => white_player_rank_2, "black_player_name_2" => black_player_name_2, "black_player_rank_2" => black_player_rank_2, "result_boolean" => result_boolean, "score" => score, "board_size" => board_size, "handi" => handi, "unixtime" => unixtime, "game_type" => game_type, "public_game" => public_game, "result" =>result}
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

    if (count > @rules.tag_pos) and (@rules.tag_boolean == true)
      for i in 0..@rules.tag_pos

        comment = game.comments
        if comment
          if comment.scan(/#{Regexp.escape(@rules.tag_phrase)}/i)
            found = true
          end
        end

        game = game.children[0]
      end
    end
    
    if (found != true) and (@rules.tag_boolean == true)
      valid_sgf = false
      invalid_reason << "did not contain tag line"
    end
  
    # Check Overtime Settings
    if game_info["OT"] == nil       # No overtime
      overtime_periods = 0
      overtime_seconds = 0

      if game_info["TM"] == nil     # No main time
        time_system = "None"
        valid_sgf = false if not @rules.time_system.split(', ').include? "None"
        invalid_reason << "game had unlimited time"

      else                          # Has main time
        time_system = "Absolute"
        valid_sgf = false if not @rules.time_system.split(', ').include? "Absolute"
        invalid_reason << "game used absolute time when not permitted to"
      end

    else                            # Has overtime
      over_time = game_info["OT"]
      over_time = over_time.split(' ')
      time_system = over_time[1]
      
      if (over_time[1] == "byo-yomi") and (@rules.ot_boolean == true) # Has Byo-yomi
        ot_split = over_time[0].split('x')

        if not @rules.time_system.split(', ').include? "Byo-Yomi"
          valid_sgf = false
          invalid_reason << "used byo-yomi overtime"
        elsif (ot_split[0].to_i < @rules.byo_yomi_periods) or (ot_split[1].to_i < @rules.byo_yomi_seconds)
          valid_sgf = false
          invalid_reason << "incorrect byo-yomi; expected: #{@rules.byo_yomi_periods}x#{@rules.byo_yomi_seconds}; was: #{ot_split[0].to_i}x#{ot_split[1].to_i}"
        end
        
      elsif (over_time[1] == "Canadian") and (@rules.ot_boolean == true) # Has Canadian
        ot_split = over_time[0].split('/')
        
        if not @rules.time_system.split(', ').include? "Canadian"
          valid_sgf = false
          invalid_reason << "used Canadian overtime"
        elsif (ot_split[0].to_i < @rules.canadian_stones) or (ot_split[1].to_i < @rules.canadian_time)
          valid_sgf = false
          invalid_reason << "incorrect canadian time settings; expected: #{@rules.canadian_stones}/#{@rules.canadian_time}; was: #{ot_split[0].to_i}/#{ot_split[1].to_i}"
        end

      else                          # Mystery Meat
        ot_split = ["0", "0"]
        
        if @rules.ot_boolean == true
          valid_sgf = false
          invalid_reason << "overtime settings were unidentifiable"
        end
      end

      overtime_periods = ot_split[0].to_i # Parse SGF overtime periods
      overtime_seconds = ot_split[1].to_i # Parse SGF overtime seconds
    end 

    # Check main time
    main_time = game_info["TM"].to_i
    
    if (main_time < @rules.main_time) and (@rules.main_time_boolean == true)
      valid_sgf = false
      invalid_reason << "incorrect main time; expected: #{@rules.main_time}; was: #{main_time}"
    end        
    
    # Check ruleset(s)
    ruleset = game_info["RU"]
    
    if @rules.ruleset_boolean == true
      
      if not @rules.ruleset.split(', ').include? ruleset
      valid_sgf = false
      invalid_reason << "incorrect ruleset; expected: #{@rules.ruleset}; was: #{ruleset}"
      end
      
    end
        
    # Check komi
    komi = game_info["KM"].to_f
    
    unless (komi == @rules.komi) or (@rules.komi_boolean == false)
      valid_sgf = false
      invalid_reason << "incorrect komi; expected: #{@rules.komi}; was: #{komi}"
    end
    
    return [overtime_periods, overtime_seconds, main_time, ruleset, komi, valid_sgf, invalid_reason, time_system]
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
    elsif games[0]["white_player_name_2"] == kgs_name
      user.rank = games[0]["white_player_rank_2"]
      user.save
    elsif games[0]["black_player_name"] == kgs_name
      user.rank = games[0]["black_player_rank"]
      user.save
    elsif games[0]["black_player_name_2"] == kgs_name
      user.rank = games[0]["black_player_rank_2"]
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
        puts "Game already in database"
        next
      end

      if (row["board_size"] != @rules.board_size) and (@rules.board_size_boolean == true)
        invalid_reason << "incorrect board size; expected: #{@rules.board_size}; was: #{row["board_size"]} "
        valid_game = false
      end

      if (row["game_type"] == "Rengo") and (@rules.rengo == false)
        invalid_reason << "rengo games not permitted"
        valid_game = false
      end

      if (row["game_type"] == "Teaching") and (@rules.teaching == false)
        invalid_reason << "teaching games not permitted"
        valid_game = false
      end
      
      if (row["game_type"] == "Review") and (@rules.review == false)
        invalid_reason << "review game not permitted"
        valid_game = false
      end
      
      if (row["game_type"] == "Demonstration") and (@rules.demonstration == false)
        invalid_reason << "demonstration game not permitted"
        valid_game = false
      end
      
      if (row["game_type"] == "Rated") and (@rules.rated == false)
        invalid_reason << "rated game not permitted"
        valid_game = false
      end
      
      if (row["game_type"] == "Free") and (@rules.free == false)
        invalid_reason << "free game not permitted"
        valid_game = false
      end

      if (not @rules.handicap.split(', ').include? row["handi"].to_s) and (@rules.handicap_boolean == true)
        invalid_reason << "incorrect handicap; expected: #{@rules.handicap}; was: #{row["handi"]}"
        valid_game = false
      end

      # That's all we can get from the KGS Archives, now to check the SGF
      sgf = sgfParser(row["url"])
      
      if @rules.ruleset == true
        
        if not @rules.ruleset.split(', ').includes? sgf[3]
          valid_game = false
          invalid_reason << "Game discarded because it used an invalid ruleset"
        end
        
      end

      if sgf[5] == false
        valid_game = false
        for x in sgf[6]
          invalid_reason << x
        end
      end
      
      player1 = row["black_player_name"]
      player2 = row["white_player_name"]
      
      if row["game_type"] == "Rengo"
        player3 = row["black_player_name_2"]
        player4 = row["white_player_name_2"]
        
        whereResult = Match.where('(black_player_name=? OR black_player_name_2=? OR white_player_name=? OR white_player_name_2=?) AND (black_player_name=? OR black_player_name_2=? OR white_player_name=? OR white_player_name_2=?) AND (black_player_name=? OR black_player_name_2=? OR white_player_name=? OR white_player_name_2=?) AND (black_player_name=? OR black_player_name_2=? OR white_player_name=? OR white_player_name_2=?)', player1, player1, player1, player1, player2, player2, player2, player2, player3, player3, player3, player3, player4, player4, player4, player4)  
        
      else
      
        whereResult = Match.where('(black_player_name=? OR white_player_name=?) AND (black_player_name=? OR white_player_name=?)', player1, player1, player2, player2)
      
      end
      
      matchnum = @rules.max_games - whereResult.length
      matchnum = 0 if matchnum < 0
      
      if whereResult.length >= @rules.max_games
        valid_game = false
        invalid_reason << "more than #{@rules.max_games} game(s) against same opponent"
      end
      
      # Points attribution
      if (valid_game == true) and (row["game_type"] == "Rengo")
        if row["result_boolean"] == false
          winner1 = User.find_by_kgs_names(row["black_player_name"])
          winner2 = User.find_by_kgs_names(row["black_player_name_2"])
          loser1 = User.find_by_kgs_names(row["white_player_name"])
          loser2 = User.find_by_kgs_names(row["white_player_name_2"])
        else
          winner1 = User.find_by_kgs_names(row["white_player_name"])
          winner2 = User.find_by_kgs_names(row["black_player_name_2"])
          loser1 = User.find_by_kgs_names(row["black_player_name"])
          loser2 = User.find_by_kgs_names(row["white_player_name_2"])
        end
          
        if winner1.points.nil?
          winner1.points = 0
        end
        if winner1.month_points.nil?
          winner1.month_points = 0
        end
        if loser1.points.nil?
          loser1.points = 0
        end
        if loser1.month_points.nil?
          loser1.month_points = 0
        end
        if winner2.points.nil?
          winner2.points = 0
        end
        if winner2.month_points.nil?
          winner2.month_points = 0
        end
        if loser2.points.nil?
          loser2.points = 0
        end
        if loser2.month_points.nil?
          loser2.month_points = 0
        end
        
        winner1.points += @rules.points_per_win * matchnum
        winner1.month_points += @rules.points_per_win * matchnum
        loser1.points += @rules.points_per_loss * matchnum
        loser1.month_points += @rules.points_per_loss * matchnum
        winner2.points += @rules.points_per_win * matchnum
        winner2.month_points += @rules.points_per_win * matchnum
        loser2.points += @rules.points_per_loss * matchnum
        loser2.month_points += @rules.points_per_loss * matchnum

        puts "#{winner1.kgs_names} +#{@rules.points_per_win * matchnum}"
        puts "#{loser1.kgs_names} +#{@rules.points_per_loss * matchnum}"
        
        puts "#{winner2.kgs_names} +#{@rules.points_per_win * matchnum}"
        puts "#{loser2.kgs_names} +#{@rules.points_per_loss * matchnum}"

        winner1.save
        loser1.save
        winner2.save
        loser2.save
        
      elsif valid_game == true 
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
        if winner.month_points.nil?
          winner.month_points = 0
        end
        if loser.points.nil?
          loser.points = 0
        end
        if loser.month_points.nil?
          loser.month_points = 0
        end

        winner.points += @rules.points_per_win * matchnum
        winner.month_points += @rules.points_per_win * matchnum
        loser.points += @rules.points_per_loss * matchnum
        loser.month_points += @rules.points_per_loss * matchnum

        puts "#{winner.kgs_names} +#{@rules.points_per_win * matchnum}"
        puts "#{loser.kgs_names} +#{@rules.points_per_loss * matchnum}"

        winner.save
        loser.save
      end

      # Everything is green, submit game to DB
      puts "Game added to db as #{valid_game}: #{invalid_reason.join(", ").capitalize}"
      rowadd = Match.new(:url => row["url"], :white_player_name => row["white_player_name"],
                                             :white_player_rank => row["white_player_rank"],
                                             :white_player_name_2 => row["white_player_name_2"],
                                             :white_player_rank_2 => row["white_player_rank_2"],
                                             :black_player_name => row["black_player_name"], 
                                             :black_player_rank => row["black_player_rank"],
                                             :black_player_name_2 => row["black_player_name_2"],
                                             :black_player_rank_2 => row["black_player_rank_2"],
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
                                             :overtime_periods => sgf[0], 
                                             :overtime_seconds => sgf[1],
                                             :time_system => sgf[7],
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