class Recommendation < ActiveRecord::Base
  belongs_to  :product
  belongs_to  :from_user, :class_name => 'User'
  has_many    :recommended_users, :dependent => :delete_all
  
  searchable do
    integer :from_user_id
    integer :recommended_user_ids, :multiple => true
    integer :product_id
  end
  
  # This is created for Activity.log_activity
  def user
    self.from_user
  end
  
end
