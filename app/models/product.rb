class Product < ActiveRecord::Base
  belongs_to              :product_line
  belongs_to              :vendor
  has_many                :reviews,             :dependent => :destroy
  has_many                :questions,           :dependent => :destroy  
  has_many                :answers,             :dependent => :destroy
  has_many                :my_collection_items
  has_many                :owners,              :source => :user, :through => :my_collection_items
  has_many                :wishlist_items,      :dependent => :destroy
  has_many                :responses,           :dependent => :destroy, :class_name => "ProductResponse"
  has_many                :comments,            :dependent => :destroy, :class_name => "ProductComment"
  
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
    text  :category_name do
      product_line.name
    end
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def like?(user)
    return Product.like?(self, user)
  end
  
  def people_who_owned
    @search = MyCollectionItem.search do
      with(:product_id, self.id)
    end
    @people_who_owned = @search.results.map { |i| i.user }
  end

  def people_who_wished 
    @search = WishlistItem.search do
      with(:product_id, self.id)      
    end
    @people_who_wished = @search.results.map { |i| i.user }
  end
  
  def self.like?(product, user)
    @search = ProductResponse.search do
      with  :product_id, product.id 
      with  :user_id, user.id
    end
    
    if @search.results.size > 0
      return true
    else
      return false
    end
  end
  
  #def self.search(search)
  #  if search
  #    where('name LIKE ?', "%#{search}%")
  #  else
  #    scoped
  #  end
  #end
end
