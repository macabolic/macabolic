class Activity < ActiveRecord::Base
  belongs_to  :user

  scope :users_activities, scoped
  scope :friends_activities, joins('INNER JOIN friendships ON friendships.friend_id = activities.user_id')
  
  scope :user_activities, lambda { |user| 
    users_activities.where('activities.user_id = ? and activities.action = ?', user.id, "create") 
  }

  scope :user_friends_activities, lambda { |user| 
    friends_activities.where('friendships.user_id = ? and activities.action = ?', user.id, "create") 
  }

  scope :questions, joins('INNER JOIN questions ON activities.type_id = questions.id').where('activities.name = ?', 'Question')
  scope :my_collection_items, joins('INNER JOIN my_collection_items ON activities.type_id = my_collection_items.id').where('activities.name = ?', 'MyCollectionItem')
  scope :my_collections, joins('INNER JOIN my_collections ON activities.type_id = my_collections.id').where('activities.name = ?', 'MyCollection')
  scope :recommendations, joins('INNER JOIN recommendations ON activities.type_id = recommendations.id').where('activities.name = ?', 'Recommendation')
  scope :my_collection_comments, joins('INNER JOIN my_collection_comments ON activities.type_id = my_collection_comments.id').where('activities.name = ?', 'MyCollectionComment')
  scope :products, joins('INNER JOIN products ON activities.type_id = products.id').where('activities.name = ?', 'Product')
  
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
  
  def recommendation
    if name == 'Recommendation'
      Recommendation.find(type_id)
    end
  end
  
  def my_collection_comment
    if name == 'MyCollectionComment'
      MyCollectionComment.find(type_id)
    end
  end  
  
  def my_collection_response
    if name == 'MyCollectionResponse'
      MyCollectionResponse.find(type_id)
    end
  end

  def my_collection_follower
    if name == 'MyCollectionFollower'
      MyCollectionFollower.find(type_id)
    end
  end
  
  def product
    if name == 'Product'
      Product.find(type_id)
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
