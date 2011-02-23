module ApplicationHelper
  def avatar_url(user)
    default_url = "#{root_url}images/default_photo.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://www.gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
#    "http://www.gravatar.com/avatar/#{gravatar_id}.png?s=48"
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
end
