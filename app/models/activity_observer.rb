class ActivityObserver < ActiveRecord::Observer
  observe :question, 
          :my_collection_item, 
          :my_collection, 
          :recommendation, 
          :my_collection_comment,
          :my_collection_response,
          :product,
          :my_collection_follower

  def after_create(model)
    log_activity('create', model)
  end

  def after_destroy(model)
    activity = Activity.where("user_id = ? and name = ? and type_id = ?", model.user.id, model.class.name, model.id).first
    if !activity.nil?
      activity.destroy
    end
  end

  private
  
  def log_activity(action_name, model)
    @activity = Activity.new
    @activity.user = model.user
    @activity.name = model.class.name
    @activity.type_id = model.id
    @activity.action = action_name
    @activity.performed_at = model.created_at   
    @activity.save
  end

end
