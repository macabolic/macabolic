# == Schema Information
# Schema version: 20101012184635
#
# Table name: reviews
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  product_id :integer
#  title      :string(255)
#  content    :text
#  avg_rating :float
#  created_at :datetime
#  updated_at :datetime
#

class Review < ActiveRecord::Base
  belongs_to  :product
  belongs_to  :user
  
end
