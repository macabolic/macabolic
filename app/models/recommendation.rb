class Recommendation < ActiveRecord::Base
  belongs_to  :product
  belongs_to  :from_user,  :class_name => 'User'
  belongs_to  :to_user,    :class_name => 'User'

  def user
    self.from_user
  end
  
end
