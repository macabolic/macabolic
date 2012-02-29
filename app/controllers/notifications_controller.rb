class NotificationsController < ApplicationController
  layout :nil
  def show
    @cat1_products = Product.where(:id => [254, 96, 102])  # For the ears
    @cat2_products = Product.where(:id => [83, 260, 247]) # For the iPad
    @cat3_products = Product.where(:id => [261, 113, 252]) # For your home
  end
  
  def send_reminder
    #users = User.where("invitation_id is null")
    users = User.where("first_name = ? and last_name = ?", "Billy", "Cheng")
    @cat1_products = Product.where(:id => [254, 96, 102])  # For the ears
    @cat2_products = Product.where(:id => [83, 260, 247]) # For the iPad
    @cat3_products = Product.where(:id => [261, 113, 252]) # For your home
    
    users.each do |user|
      logger.info "User = #{user.full_name}"
      Newsletter.reminder(user, @cat1_products, @cat2_products, @cat3_products, "We did not forget you!", HOST).deliver
    end
  end
end
