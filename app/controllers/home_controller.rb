class HomeController < ApplicationController

  def index
    #@registration = Registration.new
    if user_signed_in?
      #@member = Member.where(:email_address => current_user.email).first
      redirect_to member_path(current_user)
      #render :template => 'members/show'
    else
      @user = User.new
#      @user.first_name = "First Name"
#      @user.last_name = "Last Name"
#      @user.email = "Email Address"   
#      @user.password = "Password"   
    end
  end

end
