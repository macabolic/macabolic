# == Schema Information
# Schema version: 20100923171647
#
# Table name: my_collections
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class MyCollection < ActiveRecord::Base
  belongs_to  :user
  has_many    :products, :through => :my_collection_details
end
