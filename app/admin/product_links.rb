ActiveAdmin.register ProductLink do
  menu    :parent => "Product Maintenance", :priority => 4
  
  filter  :product
  filter  :price_range  

end
