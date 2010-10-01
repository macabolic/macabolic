module HomeHelper

  def number_of_friends_own_this_product(product)
    # 1. user.friends
    # 2. for each friend, get the list of my_collections and see if my_friend owns the product
    if product.nil?
      return 0
    else
      @count = 0
      # Got all my list of friends
      @friends = current_user.my_friends
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
  
  def calculate_lapse_time(created_at)
    @minutes = 60
    @seconds = 60
    @hours = 24
    @time_differences_in_seconds = Time.now - created_at

    logger.info "Time differences - #{@time_differences_in_seconds} seconds."
    # 59 seconds ago
    if @time_differences_in_seconds < @seconds
      @time_to_display = @time_differences_in_seconds.round
      if @time_to_display == 1
        return "#{@time_to_display} second ago"
      else
        return "#{@time_to_display} seconds ago"
      end
    # 59 minutes ago
    elsif @time_differences_in_seconds < (@seconds * @minutes)
      @time_to_display = (@time_differences_in_seconds / @seconds).round
      if @time_to_display == 1
        return "#{@time_to_display} minute ago"
      else
        return "#{@time_to_display} minutes ago"
      end
    # An hour ago or 2 hours ago
    elsif @time_differences_in_seconds < (@seconds * @minutes * @hours)
      @time_to_display = (@time_differences_in_seconds / (@seconds * @minutes)).round
      if @time_to_display == 1
        return "#{@time_to_display} hour ago"
      else
        return "#{@time_to_display} hours ago"
      end
    # A day ago or 4 days ago
    else
      @time_to_display = (@time_differences_in_seconds / (@seconds * @minutes * @hours)).round      
      if @time_to_display == 1
        return "#{@time_to_display} day ago"
      else 
        return "#{@time_to_display} days ago"
      end
    end

    return @time_to_display
  end
  
end
