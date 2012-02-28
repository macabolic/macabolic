class VendorResponse < ActiveRecord::Base
  belongs_to  :vendor
  belongs_to  :user
  
  searchable do
    integer :vendor_id
    integer :user_id
  end
end
