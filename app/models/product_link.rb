class ProductLink < ActiveRecord::Base
  belongs_to  :product
  belongs_to  :informer,          :class_name => "User",  :foreign_key => "informer_id"
  belongs_to  :price_range
end
