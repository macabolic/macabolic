class WishlistItem < ActiveRecord::Base
  belongs_to  :wishlist
  belongs_to  :product
  belongs_to  :user
  
  attr_accessible         :user_id, :product_id, :wishlist_id
  
  searchable do
    integer :wishlist_id
    integer :user_id
    integer :product_id
    string  :product_name
  end
        
  def product_name
    self.product.name
  end
  
end
