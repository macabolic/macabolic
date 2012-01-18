class UserMailer < ActionMailer::Base
  default :from => "The Macabolic Team <general.support@macabolic.com>"
  
  def invite(invitation, reminder = false)
    @invitation = invitation
    @subject = "You are invited to join Macabolic"
    @to = invitation.recipient_email
    @reminder = reminder
    @domain = "teaser.macabolic.com"
    
    mail( :from => "The Macabolic Team <general.support@macabolic.com>", :to => @to, :subject => @subject) do |format|
      format.html { render 'invitation' }
    end
  end
  
end
