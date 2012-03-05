class UserMailer < ActionMailer::Base
  default :from => "The Macabolic Team <general.support@macabolic.com>"
  
  def invite(invitation, reminder = false)
    @invitation = invitation
    @subject = "You are invited to join Macabolic"
    @to = invitation.recipient_email
    @reminder = reminder
    @domain = "www.macabolic.com"
    
    mail( :from => "The Macabolic Team <general.support@macabolic.com>", :to => @to, :subject => @subject) do |format|
      format.html { render 'invitation' }
    end
  end
  
  def beta_invitation(inviting_user, invitation)
    @host = "www.macabolic.com"
    @user = inviting_user
    @invitation = invitation
    @subject = "Your wait is over! Welcome to Macabolic"
    @to = invitation.recipient_email
    @domain = "www.macabolic.com"
    
    mail( :from => "The Macabolic Team <general.support@macabolic.com>", :to => @to, :subject => @subject) do |format|
      format.html { render 'beta_invitation' }
    end    
  end
  
  def welcome(welcome_user)
    @host = "www.macabolic.com"
    @user = welcome_user
    @subject = "You become a Macabolic now"
    @to = welcome_user.email
    @domain = "www.macabolic.com"
    
    mail( :from => "The Macabolic Team <general.support@macabolic.com>", :to => @to, :subject => @subject) do |format|
      format.html { render 'welcome_mail' }
    end        
  end
  
  def friend_request(user, inviting_user)
    @user = user
    @inviting_user = inviting_user
    @subject = "#{user.full_name} would like to be a friend in Macabolic"
    @to = inviting_user.email
    @domain = "www.macabolic.com"
    
    mail( :from => "The Macabolic Team <general.support@macabolic.com>", :to => @to, :subject => @subject) do |format|
      format.html { render 'friend_request' }
    end        
  end
  
end
