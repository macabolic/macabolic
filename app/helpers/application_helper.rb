module ApplicationHelper
  def avatar_url(user, size)
    default_url = "#{root_url}images/default_photo.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
#    "http://www.gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
    "http://www.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm"
  end
  
  def sortable(column, title = nil)  
    title ||= column.titleize  
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"  
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end
  
  def show_default_wishlist(user)
    if user.has_default_wishlist?
      return Wishlist.default_wishlist(user)
    else
      return nil
    end
  end  
  
  def title(page_title)
    content_for(:title) { page_title }
  end
   
  def lapsed_time(time)
    @minutes = 60
    @seconds = 60
    @hours = 24
    @time_differences_in_seconds = Time.now - time

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
        return "An hour ago"
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
