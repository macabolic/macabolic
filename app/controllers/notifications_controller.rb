class NotificationsController < ApplicationController
  layout :nil
  def show
    #@cat1_products = Product.where(:id => [254, 96, 102])  # For the ears
    #@cat2_products = Product.where(:id => [83, 260, 247]) # For the iPad
    #@cat3_products = Product.where(:id => [261, 113, 252]) # For your home
    
    @cat1_products = Product.where(:product_line_id => 6).limit(3)  # For the ears
    @cat2_products = Product.where(:product_line_id => 3).limit(3) # For the iPad
    @cat3_products = Product.where(:product_line_id => 1).limit(3) # For your home
    
  end
  
  def send_reminder
    users = User.where("invitation_id is null")
    #users = User.where("first_name = ? and last_name = ?", "Billy", "Cheng")
    @cat1_products = Product.where(:id => [254, 96, 102])  # For the ears
    @cat2_products = Product.where(:id => [78, 260, 247]) # For the iPad
    @cat3_products = Product.where(:id => [261, 253, 252]) # For your home
    
    users.each do |user|
      logger.debug "User = #{user.full_name}"
      Newsletter.reminder(user, @cat1_products, @cat2_products, @cat3_products, "We did not forget you!", HOST).deliver
    end
  end
  
  def beta_invitation
    @host = "#{HOST}"
    #users = User.where("email = ? and invitation_id is null", "billy.cheng@macabolic.com")
    users = User.where("invitation_id is null")
    users.each do |user|
      #@invitation = Invitation.find(18)
      @invitation = Invitation.new(:sender_id => -999, :recipient_email => user.email)
      @invitation.save
      UserMailer.beta_invitation(user, @invitation).deliver
      @invitation.update_attribute("sent_at", Time.now)
    end
  end

end