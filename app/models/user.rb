class KGSValidator < ActiveModel::Validator
  def validate(record)

    # Record has all the submission info. record.errors will give you the error handler.

    require 'open-uri'
    name = record.kgs_names

    doc = Nokogiri::HTML(open("http://www.gokgs.com/gameArchives.jsp?user=#{name}"))
    doc = doc.xpath('//table[1]')
    doc = doc.css('tr:not(:first)')

    if not doc.first:
      # Errors if there is no KGS page
      record.errors[:kgs_names] << ("The KGS account you entered does not exist. Please ensure that your name matches the KGS name exactly.")
      return
    end

    a = doc.first.css('td a')[0].content.scan(/(\w+)/)
    b = doc.first.css('td a')[1].content.scan(/(\w+)/)

    # Politely changes the name to the correct version we scraped from the site.
    if a[0][0].casecmp(name) == 0
      record.kgs_names = a[0][0]
    elsif b[0][0].casecmp(name) == 0
      record.kgs_names = b[0][0]
    else
      # Errors if we can't verify the account due to lack of games this month.
      record.errors[:kgs_names] << ("The KGS account you entered has not played any games lately, and we were unable to verify it. Please make certain you have at least one game, review, or demo this month.")
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

