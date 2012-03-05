class ProductLine < ActiveRecord::Base
  has_many    :products
  #belongs_to  :vendor  
  
  def to_s
    return name
  end
end
