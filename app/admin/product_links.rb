ActiveAdmin.register ProductLink do
  menu    :parent => "Product Maintenance", :priority => 4
  
  filter  :product
  filter  :price_range  

  index do
    column  "Id" do |product_link|
      link_to product_link.id, admin_product_link_path(product_link)
    end
    column  "Product" do |product_link|
      link_to product_link.product.name, admin_product_path(product_link.product)
    end
    column  :link
    column  :promote_url
    default_actions
  end

end
