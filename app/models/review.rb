class Review < ActiveRecord::Base
  belongs_to  :user   # This user is the original author of the review.
  belongs_to  :product
  has_many    :review_responses, :dependent => :destroy
  
  validates :title,   :presence => true,
                      :length => { :minimum => 5 }
  validates :content, :presence => true
      
  scope :vote_like, joins(:review_responses).where('review_responses.response_for = ?', true)
  scope :vote_unlike, joins(:review_responses).where('review_responses.response_for = ?', false)
      
  def lapsed_time
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
   
  def is_author?(user)
    self.user = user
  end
  
#  def is_reviewed?(user)
#    ReviewResponse.where("review_id = ? and user_id = ?", self.id, user.id).exists?
#  end
    
  def responded_by(user)
    ReviewResponse.where("user_id = ? and review_id = ?", user.id, self.id)
  end
  
end
