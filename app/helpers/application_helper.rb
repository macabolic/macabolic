module ApplicationHelper
  def avatar_url(user, size)
    default_url = "#{root_url}images/default_photo.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
#    "http://www.gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
    "http://www.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm"
  end
  
  def current_profile_image_url(user)
    default_url = "/images/default_photo.png"
    
    if user.profile_image_set?
      provider = user.current_profile_image.provider
      if provider == ProfileImage::MACABOLIC
        return user.avatar.url(:medium)
      elsif provider == ProfileImage::FACEBOOK
        return "http://graph.facebook.com/#{user.current_profile_image.uid}/picture?type=large"
      elsif provider == ProfileImage::GRAVATAR
        gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
        return "http://www.gravatar.com/avatar/#{gravatar_id}.png?s=180&d=mm"        
      end
    end
    
    return default_url
  end

  def current_profile_image_thumbnail_url(user)
    default_url = "/images/default_photo_50.png"
    
    if user.profile_image_set?
      provider = user.current_profile_image.provider
      if provider == ProfileImage::MACABOLIC
        return user.avatar.url(:thumb)
      elsif provider == ProfileImage::FACEBOOK
        return "http://graph.facebook.com/#{user.current_profile_image.uid}/picture?type=square"
      elsif provider == ProfileImage::GRAVATAR
        gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
        return "http://www.gravatar.com/avatar/#{gravatar_id}.png?s=50&d=mm"        
      end
    end
    
    return default_url
  end

  def macabolic_profile_image_url(user, provider, size) 
    default_url = "/images/default_photo_50.png"
    macabolic = user.profile_images.where(:provider => ProfileImage::MACABOLIC)
    if macabolic.size > 0
      # thumb, small, medium and large
      return user.avatar.url(size)
    else         
      return default_url    
    end
  end

  def facebook_profile_image_url(user, provider, size) 
    default_url = "/images/default_photo_50.png"
    facebook = user.profile_images.where(:provider => ProfileImage::FACEBOOK)
    if facebook.size > 0
      # Type: square (50x50)
      #       small (50 pixels wide, variable height) 
      #       normal (100 pixels wide, variable height)
      #       large (about 200 pixels wide, variable height)
      return "http://graph.facebook.com/#{facebook[0].uid}/picture?type=#{size}"
    else    
      return default_url    
    end
  end

  def facebook_profile_image(facebook_id, size) 
    default_url = "/images/default_photo_50.png"
    if !facebook_id.nil?
      # Type: square (50x50)
      #       small (50 pixels wide, variable height) 
      #       normal (100 pixels wide, variable height)
      #       large (about 200 pixels wide, variable height)
      return "http://graph.facebook.com/#{facebook_id}/picture?type=#{size}"
    else    
      return default_url    
    end
  end

  def gravatar_profile_image_url(user, provider, size) 
    default_url = "/images/default_photo_50.png"
    gravatar = user.profile_images.where(:provider => ProfileImage::GRAVATAR)
    if gravatar.size > 0
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      return "http://www.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm"                
    else
      return default_url    
    end
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

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end  
end
