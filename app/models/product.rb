class Product < ActiveRecord::Base
  belongs_to              :product_line
  belongs_to              :vendor
  has_many                :reviews, :dependent => :destroy
  has_many                :questions, :dependent => :destroy  
  has_many                :my_collection_items
  has_many                :users, :through => :my_collection_items
  
  has_attached_file       :thumbnail, 
                          :styles => { :medium => "300x300>", :thumb => "100x100>" },
                          :url => "/assets/products/:attachment/:id/:style/:filename",
                          :path => ":rails_root/public/assets/products/:attachment/:id/:style/:filename"

  attr_accessible         :name, :thumbnail, :vendor_id, :product_line_id
  
  searchable do
    text  :name
    text  :vendor_name do
      vendor.name
    end
  end
  
  def people_who_owned
      @search = MyCollectionItem.search do
        with(:product_id, self.id)
      end
      @people_who_owned = @search.results.map { |i| i.user }
  end
    
  #def self.search(search)
  #  if search
  #    where('name LIKE ?', "%#{search}%")
  #  else
  #    scoped
  #  end
  #end
end
