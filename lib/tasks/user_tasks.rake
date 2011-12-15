desc "Register users"
task :signup_users => :environment do

  usernames = ["shinichi56", "bartimeus", "compgo74", "faceless1", "deathwind", "drgoplayer", "plusguy", "fab", "jozles", "joenosai", "geser", "eddy", "baddack", "lonelyjoy", "joeseki", "katchumo", "ikeike", "teach", "niark", "tanushka", "drogba987", "bert", "mo", "benjii", "gabalon", "ciaso", "jubilex", "thecmvick", "boule2", "thesirjay", "fern", "gryn", "dmitriy81", "startagain", "merula", "edisson", "latios", "tlapeg07", "hellhuman", "ocrilim", "nannyogg", "turingtest", "orunandaka", "moichido", "ddusopp", "freehold", "sleazywiki", "dreamc", "agzam", "lemike", "schrody", "ryuu", "usagi", "gaechka", "helloqtion", "fran6", "jtscarry", "senyuki"]
  
  for x in usernames
    sleep(12)
    puts "Saving #{x}"
    @user = User.new(:username => x, :kgs_names => x, :email => "#{x}@test.com", :password => "testtest", :password_confirmation => "testtest")
    @user.save!
  end
end
  