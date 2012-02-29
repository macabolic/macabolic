class Newsletter < ActionMailer::Base
  default :from => "Macabolic.com <newsletter@macabolic.com>"

  def monthly(user_list, subject)
    @users = user_list
    @products = Product.limit(16).order("updated_at DESC")
    
    @users.each do |user|
      mail(:to => user, :subject => subject)
    end
  end
  
  def reminder(user, cat1_products, cat2_products, cat3_products, subject, host)
    @user = user
    @cat1_products = cat1_products
    @cat2_products = cat2_products
    @cat3_products = cat3_products
    @host = host
    
    mail(:to => @user.email, :subject => subject)

  end
  
end
