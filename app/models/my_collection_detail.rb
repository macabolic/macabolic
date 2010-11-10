# == Schema Information
# Schema version: 20100923171647
#
# Table name: my_collection_details
#
#  id               :integer         not null, primary key
#  my_collection_id :integer
#  product_id       :integer
#  purchased_in     :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class MyCollectionDetail < ActiveRecord::Base
  belongs_to  :my_collection
  belongs_to  :product
  
  def number_of_friends_own_this
    # 1. user.friends
    # 2. for each friend, get the list of my_collections and see if my_friend owns the product
    if product.nil?
      return 0
    else
      @count = 0
      # Got all my list of friends
      @friends = my_collection.user.my_friends
      logger.info "I have #{@friends.size} friends."
      
      # For each friend
      @friends.each do |friend|
        logger.info "My friend (#{friend.friend.login}) has #{friend.friend.my_collections}"
        friend.friend.my_collections.each do |my_collection|
          my_product = MyCollectionDetail.find(:first, :conditions => {:my_collection_id => my_collection.id, :product_id => product.id})
          if !my_product.nil?
            @count += 1
          end          
        end
      end
      
      return @count
    end   
  end
  
end
