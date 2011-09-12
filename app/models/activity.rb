class Activity < ActiveRecord::Base
  belongs_to  :user

  scope :users_activities, scoped
  scope :friends_activities, joins('INNER JOIN friendships ON friendships.friend_id = activities.user_id')
  
  scope :user_activities, lambda { |user| 
    users_activities.where('activities.user_id = ?', user.id) 
  }

  scope :user_friends_activities, lambda { |user| 
    friends_activities.where('friendships.user_id = ?', user.id) 
  }
  
  def question
    if name == 'Question'
      Question.find(type_id)
    end
  end
  
  def my_collection_item
    if name == 'MyCollectionItem'
      MyCollectionItem.find(type_id)
    end
  end
  
  def my_collection
    if name == 'MyCollection'
      MyCollection.find(type_id)
    end
  end
  
  def lapsed_time
    @minutes = 60
    @seconds = 60
    @hours = 24
    @time_differences_in_seconds = Time.now - performed_at

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
