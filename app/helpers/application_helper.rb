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
  
  def get_matches
    
    kgsnames = User.find(:all, :select => "kgs_names")
    
    for x in kgsnames
      puts x.kgs_names
    end
    
    usernames = User.find(:all, :select => "username")
    
    for x in usernames
      puts x.username
    end   
  end
  
  def scrape
    
    kgsnames = User.find(:all, :select => "kgs_names")
    
    for x in kgsnames
      if x.kgs_name == nil
        next
      end
      match_scraper(x.kgs_name)
    end
  end

  def processRow(row)
    # This next line gets the 1st <a> tag in the first <td> tag (which is our sgf link), or nil if it's a private game.
    url = row.at('a')[:href]

    columns = row.css('td')
    public_game = columns[0].content
    
    # Calculate white player name and rank
    white_player_name = columns[1].content.scan(/^\w+/)[0]
    white_player_rank = columns[1].content.scan(/\?|-|[1-9]?[1-9][kdp]/)
    white_player_rank = rank_convert(white_player_rank)
    
    # Calculate black player name and rank
    black_player_name = columns[2].content.scan(/^\w+/)[0]
    black_player_rank = columns[2].content.scan(/\?|-|[1-9]?[1-9][kdp]/)
    black_player_rank = rank_convert(black_player_rank)
    
    # Parse board size
    board_size_and_handicap = columns[3].content
    boardArray = columns[3].content.scan(/[0-9]+/)
    board_size = Integer(boardArray[0])
  
    if boardArray.length() == 3
      handi = Integer(boardArray[2])
    else
      handi = Integer(0)
    end
    
    # Calculate UNIX time
    date = columns[4].content
    unixtime = DateTime.strptime(date, "%m/%d/%Y %I:%M %p").utc.to_time.to_i * -1
    
    game_type = columns[5].content
    
    # Parse game results
    result = columns[6].content
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

  def parseSGF(url)
    # SGF Parser
    
    require 'net/http'
    require 'open-uri'
    require 'sgf'
    sgf_raw = open(url).read
    parser = SGF::Parser.new 
    tree = parser.parse sgf_raw
    
    game_info = tree.root.children[0].properties
    
    # Check that over time is at least 5x30 byo-yomi
    over_time = game_info["OT"]
    if over_time == nil
      return false
    end
    
    # Omit games with the Canadian ruleset
    if over_time["Canadian"]
      return false
    end
    
    # Restrict overtime settings
    over_time = over_time.split(' ')
    byo_yomi_periods = over_time[0].split('x')[0].to_i # Parse SGF overtime periods
    byo_yomi_seconds = over_time[0].split('x')[1].to_i # Parse SGF overtime seconds

    if (byo_yomi_periods < 5) and (byo_yomi_stones < 30)
      return false
    end
    
    # Check main time is not less than 1500
    main_time = game_info["TM"].to_i
    
    if main_time < 1500
      return false
    end        
    
    # Check ruleset is Japanese
    ruleset = game_info["RU"]
    
    if ruleset != "Japanese"
      return false
    end
    
    # Check komi is 6.5
    komi = game_info["KM"][1..-2].to_f
    
    if komi != 6.5
      return false
    end

    # Confirm 'ASR League' is mentioned within first 30 moves
    game = tree.root
    valid = false
    for i in 0..30
      comment = game.properties["C"]
      if comment.scan(/ASR League/i)
        valid = true
      end
      game = game.children[0]
    end
    
    if valid != true
      return false
    end

    return [byo_yomi_periods, byo_yomi_seconds, main_time, ruleset, komi]
  end

  def match_scraper(kgs_name)
    
    require 'open-uri'
    require 'time'
      
    doc = Nokogiri::HTML(open("http://www.gokgs.com/gameArchives.jsp?user=#{kgs_name}"))
    doc = doc.xpath('//table[1]')
    doc = doc.css('tr:not(:first)')
    
    games = []
    
    doc.each do |row|
      games << processRow(row)
    end
    
    # Various filters
    for row in games
      if row["public_game"] == "No"
        next
      elsif row["board_size"] != 19
        next
      elsif row["game_type"] == "Rengo"
        next
      elsif row["game_type"] == "Teaching"
        next
      elsif row["handi"] != 0
        next
      else
        sgf = sgfParser(row["url"])
        
        if sgf == False:
          next
        end

        # Submit game to DB
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
                                               :valid => valid, 
                                               :result => row["result"],
                                               :byo_yomi_periods => sgf[0], 
                                               :byo_yomi_seconds => sgf[1])
        rowadd.save
      end # End if .. else statement
    end # End for loop
   
   end
  
end
