class Product < ActiveRecord::Base
  belongs_to              :product_line
  belongs_to              :vendor
  
  has_attached_file       :thumbnail, 
                          :styles => { :medium => "300x300>", :thumb => "100x100>" },
                          :url => "/assets/products/:attachment/:id/:style/:filename",
                          :path => ":rails_root/public/assets/products/:attachment/:id/:style/:filename"
                          
end
