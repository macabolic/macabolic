class MyCollection < ActiveRecord::Base
  belongs_to  :user
  has_many    :my_collection_items,       :dependent => :destroy
  has_many    :my_collection_responses,   :dependent => :destroy

  has_attached_file       :thumbnail, 
                          :styles => { :medium => "300x300>", :thumb => "100x100>" },
                          :url => "/assets/members/my_collections/:attachment/:id/:style/:filename",
                          :path => ":rails_root/public/assets/members/my_collections/:attachment/:id/:style/:filename",
                          :default_url => "/images/product/no-image_:style.jpg",
                          :default_style => :thumb
  
  DEFAULT_COLLECTION_NAME = "My Collection"
  
  def self.add_product_to_collection(user, product)
    # 1. Create default 'My Collection', if necessary
    my_collection = self.create_default_if_not_present(user)
    
    # 2. Initiate MyCollectionItem
    my_collection_item = MyCollectionItem.new(:my_collection_id => my_collection.id, :product_id => product.id)
    my_collection_item.save
    
    return my_collection
  end
  
  def self.create_default_if_not_present(user)
    # First check if that user has a default my_collection
    if self.defined_default_collection?(user)
      my_collection = self.default_collection(user)
    else
      my_collection = MyCollection.create(:name => DEFAULT_COLLECTION_NAME, :user_id => user.id)
    end

    return my_collection
  end

  def self.defined_default_collection?(user)
    where("user_id = ? AND name = ?", user.id, DEFAULT_COLLECTION_NAME).exists?
  end

  def self.default_collection(user)
    where("user_id = ? AND name = ?", user.id, DEFAULT_COLLECTION_NAME).first
  end
  
  def responded_by(user)
    MyCollectionResponse.where("user_id = ? and my_collection_id = ?", user.id, self.id)
  end
  
end
