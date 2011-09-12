class MyCollectionItem < ActiveRecord::Base
  belongs_to  :my_collection
  belongs_to  :product
  belongs_to  :user
  
  cattr_reader  :per_page
  @@per_page = 10
    
  attr_accessible         :user_id, :product_id, :my_collection_id
  
  searchable do
    integer :my_collection_id
    integer :user_id
    integer :product_id
    string  :product_name
  end
        
  def product_name
    self.product.name
  end
  
end
