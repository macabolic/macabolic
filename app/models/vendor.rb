class Vendor < ActiveRecord::Base
  has_many    :products
  has_many    :responses,                 :dependent => :destroy, :class_name => "VendorResponse"
  has_many    :followers,                 :dependent => :destroy, :class_name => "VendorFollower"
  
  searchable do
    text  :vendor_name do
      self.name
    end
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def like?(user)
    return Vendor.like?(self, user)
  end
  
  def self.like?(vendor, user)
    @search = Sunspot.search(VendorResponse) do
      with  :vendor_id, vendor.id 
      with  :user_id, user.id
    end
    
    if @search.results.size > 0
      return true
    else
      return false
    end
  end
  
end
