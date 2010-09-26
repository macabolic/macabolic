class MyCollection < ActiveRecord::Base
  belongs_to  :user
  has_many    :products, :through => :my_collection_details
end
