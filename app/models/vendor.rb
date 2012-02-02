class Vendor < ActiveRecord::Base
  has_many  :products
  
  searchable do
    text  :vendor_name do
      self.name
    end
  end
  
end
