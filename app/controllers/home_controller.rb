class HomeController < ApplicationController
  def index
    #@registration = Registration.new
    if user_signed_in?
      @member = Member.where(:email_address => current_user.email)
      render :template => 'members/show'
    else
      
    end
  end

end
