class MyCollection < ActiveRecord::Base
  has_many  :my_collection_items,   :dependent => :destroy
end
