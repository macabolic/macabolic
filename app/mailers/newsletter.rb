class Newsletter < ActionMailer::Base
  default :from => "newsletter@macabolic.com"
  
  def monthly(email_list, subject)
    @email_list = email_list
    @products = Product.limit(16).order("updated_at DESC")
    
    mail(:to => email_list, :subject => subject)
  end
  
end
