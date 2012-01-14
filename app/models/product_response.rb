class ProductResponse < ActiveRecord::Base
  belongs_to  :product
  belongs_to  :user
  
  searchable do
    integer :product_id
    integer :user_id
  end
  
end
