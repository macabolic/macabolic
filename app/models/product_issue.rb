class ProductIssue < ActiveRecord::Base
  belongs_to  :product
  belongs_to  :reporter,          :class_name => "User",  :foreign_key => "reporter_id"  
end
