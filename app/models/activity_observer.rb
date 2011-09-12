class ActivityObserver < ActiveRecord::Observer
  observe :question, :my_collection_item, :my_collection

  def after_create(model)
    log_activity(model)
  end
  

  private
  
  def log_activity(model)
    @activity = Activity.new
    @activity.user = model.user
    @activity.name = model.class.name
    @activity.type_id = model.id
    @activity.action = 'create'
    @activity.performed_at = model.created_at   
    @activity.save
  end

end
