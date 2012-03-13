class ProductComment < ActiveRecord::Base
  belongs_to  :product, :counter_cache => false
  belongs_to  :user

  searchable do
    text    :content
    integer :product_id
    integer :user_id
  end

  def lapsed_time
    @minutes = 60
    @seconds = 60
    @hours = 24
    @time_differences_in_seconds = Time.now - created_at

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
