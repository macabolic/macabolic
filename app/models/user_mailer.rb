class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new Macabolic account'
  
    @body[:url]  = "http://www.macabolic.com/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your Macabolic account has been activated!'
    @body[:url]  = "http://www.macabolic.com/"
  end
  
  def invitation(user, invitation, signup_url)
    @subject = "#{user.display_name} invites you to join Macabolic.com."
    @recipients = invitation.recipient_email
    @from = "digitalmacliving@gmail.com"
    @body[:user] = user
    @body[:invitation] = invitation
    @body[:signup_url] = signup_url
    invitation.update_attribute(:sent_at, Time.now)
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "ADMINEMAIL"
      @subject     = ""
      @sent_on     = Time.now
      @body[:user] = user
    end
end
