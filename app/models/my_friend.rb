# == Schema Information
# Schema version: 20100923171647
#
# Table name: my_friends
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class MyFriend < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :friend, :class_name => "User"
end
