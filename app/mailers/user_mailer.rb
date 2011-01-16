class UserMailer < ActionMailer::Base
  default :from => "The Macabolic Team <support@macabolic.com>"
  
  def thank_you_email(registration)
    @registered_user = registration
    mail( :to => registration.email_address, 
          :subject => "Thank you for your interest in Macabolic.com!" ) do |format|
          format.html { render 'thank_you' }
          #format.text { render 'thank_you' }
    end
  end
end
