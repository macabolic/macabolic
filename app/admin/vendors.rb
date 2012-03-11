ActiveAdmin.register Vendor do
  menu    :parent => "Product Maintenance", :priority => 2  
  
  form :html => { :multipart => true } do |f|
      f.inputs "Product" do
        f.input :name
        f.input :logo, :as => :file
      end
      f.buttons
  end  
  
end
