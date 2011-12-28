desc "Register users"
task :signup_users => :environment do

  usernames = { "Alpha" => ["shinichi56", "fab", "bartimeus", "faceless1", "compgo74", "drgoplayer", "deathwind", "jozles", "eddy", "plusguy", "joenosai", "baddack", "geser", "katchumo", "lonelyjoy", "joeseki", "ikeike", "teach"],
                "Beta I" => ["niark", "tanushka", "drogba987", "bert", "mo", "benjii", "gabalon", "ciaso", "jubilex", "thecmvick", "boule2", "thesirjay", "fern", "gryn", "dmitriy81", "startagain", "merula", "edisson", "latios", "tlapeg07"],
                "Beta II" => ["hellhuman", "ocrilim", "nannyogg", "turingtest", "senyuki", "ddusopp", "orunandaka", "moichido", "sleazykiwi", "dreamc", "agzam", "lemike", "jtscarry", "schrody", "ryuu", "usagi", "gaechka", "helloqtion", "fran6"],
                "Gamma I" => ["werfeus", "dr4ch3", "redline", "whatley", "kitani23", "kanmuru", "diethxbye", "panbr1", "jachugan", "davy014", "akoji", "aperezwi", "lucianos", "catsoldier", "stevek", "robby60638", "nh3ch2cooh", "goinsei", "blueprince", "mrshintou", "eiszaepfle"],
                "Gamma II" => ["photios", "alchemy", "zebra131", "tomoyakun", "eeveem", "igneel", "sshiva12", "pento", "petersmol", "kemeken", "quito", "lailaihei", "vdk", "kat3", "astaldo", "coldmen", "kenyhd", "katsushiro", "tunabeast", "practise", "z0mbies"],
                "Gamma III" => ["gui54", "kwinin", "fenring", "danielxr", "smarre", "hansollo", "deshi", "ingless", "goal99", "demiurgos", "smokimo", "hellsflame", "lordvader", "nfo", "waynec", "myownstr", "viu30h", "zep", "barrauss", "krissy"],
                "Gamma IV" => ["kirasaki", "magnus86", "dateless", "nottengen", "ez4u", "adius", "rosenzweig", "vip", "hirensou", "zybex86", "whiteberry", "harusaki", "xzenith42", "familara", "richilue", "jagon", "redgrave", "jummcgrum", "shapemaker", "gorival", "hailthorn"],
                "Delta" => ["kabradarf", "clement44", "ogataseiji", "lowlander", "asm", "isbhal", "happyxmas", "mitxy19", "flexn", "rainerle", "toichi", "kurii", "domination", "fluffm", "dfunkt", "doiel", "v", "karaklis", "mrznf", "hbw", "rawrmoo", "casio", "fortuny", "xenorosth", "olim2009", "yusakukudo", "slowhand", "killerx", "busta", "xsuperbiax", "kyu4life", "benjamingl", "zoup", "dedyz", "hipparion", "ronyazerez", "mendieta", "levvo", "dunkelheit", "sylar1", "septy", "alex666", "rav", "keshi", "jwdown", "nathan", "kuroro", "jenj", "goldd", "palko", "badge", "kamomille", "alpha143", "mrguigui", "shrestha", "psitheta", "redreoicy", "explo", "micha96", "nigeto", "pentatonic", "mimir", "snip", "gekonus", "madavenger", "sloy", "akarika", "caelestis", "bertoo", "kaminoyari", "kemist", "leachy", "tenrai", "madfargus", "pzan", "the42", "superfly", "oye", "schaz", "fery", "psychee", "shinjide", "nimbim", "dinocow", "bobbyconn", "kotomi", "buzzsaw", "user323", "marcus316", "baconade", "erekose", "elpirata", "dankenzon", "repoman", "zs", "trudeln", "dodecality", "myexe", "ken1jf", "brian12", "mackenzie", "could", "nukeu666", "fushigihi", "vzaxer", "rberenguel", "oglop", "gerlige", "sur", "advanced", "olaf", "wery", "honibox3", "escaper69", "indie9", "aidan", "bogdan", "rochercg", "luk", "legatus7", "lance123", "jokep", "dcnogo", "gipson2", "jwalker", "azubi", "mathe123", "tsumegoj", "yoon", "nosabe", "slayan", "kkkekai", "gorjanc", "ambyr00", "radishimo", "tramanh", "rachela", "gelya", "blitzeur", "yaoundee", "mmk", "johnc", "morriell", "jlengyel", "diomede", "kpucc", "falfan1", "loki", "madrock", "pandagruel", "otakujack", "caribe", "lied", "sandb0x", "kait", "doc14", "aspara", "go2eleven", "sdd", "katsu7", "aye", "slayne", "merclgt", "kanti", "starlight8", "psprof"]
              }

  usernames.each_key do |division|
    names = usernames[division]
    names.each do |x|
        puts "Saving #{x}"
        @user = User.new(:username => x, :kgs_names => x, :email => "#{x}@test.com", :password => "testtest", :password_confirmation => "testtest")
        @user.division = division
        @user.save!
        sleep(3)
    end
  end
  
end
  
