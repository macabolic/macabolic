class PriceRange < ActiveRecord::Base
  has_many :product_link
  
  def display
    "$#{from_price} - #{to_price}"
  end
  
end
