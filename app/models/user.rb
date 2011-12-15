class KGSValidator < ActiveModel::Validator

  # Eventually, remove rank_convert and replace with an appropriate reference to the application_helper method
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
  
  def validate(record)

    # Record has all the submission info. record.errors will give you the error handler.

    require 'open-uri'
    name = record.kgs_names

    doc = Nokogiri::HTML(open("http://www.gokgs.com/gameArchives.jsp?user=#{name}"))

    # Errors if page does not contain at least one game record
    if doc.css("h2").inner_html.include? '(0 games)'
      #record.errors[:kgs_names] << ("The KGS account you entered has not played any games lately, and we were unable to verify it. Please make certain you have at least one game, review, or demo this month.")
      return
    end

    doc = doc.xpath('//table[1]')
    doc = doc.css('tr:not(:first)')
     
    # Errors if there is no KGS page
    if not doc.first
      record.errors[:kgs_names] << ("The KGS account you entered does not exist. Please ensure that your name matches the KGS name exactly.")
      return
    end
    

    myRegex =  /(\w+) \[(\?|-|\w+)\??\]/

    a = doc.first.css('td')[1].content.scan(myRegex)
    b = doc.first.css('td')[2].content.scan(myRegex)

    # Politely changes the name to the correct version we scraped from the site.
    if a[0][0].casecmp(name) == 0
      record.kgs_names = a[0][0]
      record.rank = rank_convert(a[0][1])
    elsif b[0][0].casecmp(name) == 0
      record.kgs_names = b[0][0]
      record.rank = rank_convert(b[0][1])
    #else
    end
  end
end


class User < ActiveRecord::Base
  
  validates_presence_of :username
  validates_presence_of :kgs_names

  validates_with KGSValidator

  has_many :matches
  has_many :points
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :username, :kgs_names

end

