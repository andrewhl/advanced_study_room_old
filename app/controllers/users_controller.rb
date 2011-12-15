class UsersController < ApplicationController
  def index  
  end
  
  def add_to_division
    
  end
  
  def add_to_waiting_list
    
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    require 'open-uri'

    name = params[:kgs_names]
    doc = Nokogiri::HTML(open("http://www.gokgs.com/gameArchives.jsp?user=#{name}"))

    doc = doc.xpath('//table[1]')
    doc = doc.css('tr:not(:first)')
    a = doc.first.css('td a')[1].content.scan(/(\w+)/)
    b = doc.first.css('td a')[2].content.scan(/(\w+)/)

    if a[0][0].casecmp(name) == 0
      correct_name = a[0][0]
      user = User.create(:kgs_names => correct_name)
    elsif b[0][0].casecmp(name) == 0
      correct_name = b[0][0]
      user = User.create(:kgs_names => correct_name)
    else
      errors.add_to_base "We were unable to verify your KGS username. Please ensure that your name matches the KGS name exactly, case sensitive."
    end
  end
  
  def update_kgs_names
   @user = User.find params[:id]
   if @user.update_attributes(params[:kgs_names])
    render :text => "Success"
   else
    render :text => "Error", :status => 500
   end
  end

end
