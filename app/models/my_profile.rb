# == Schema Information
# Schema version: 20100923171647
#
# Table name: my_profiles
#
#  id                 :integer         not null, primary key
#  user_id            :integer
#  first_name         :string(255)
#  last_name          :string(255)
#  gender             :string(255)
#  country            :string(255)
#  birthday           :date
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class MyProfile < ActiveRecord::Base
  belongs_to  :user
  
  has_attached_file :photo, :styles => { :small => "150x150>"},
                    :url => "/assets/users/my_profiles/:attachment/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/users/my_profiles/:attachment/:id/:style/:basename.:extension"
                    
  validates_attachment_presence :photo
  validates_attachment_size     :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  def full_name
    fn = first_name
    fn = fn + ' ' if !first_name.nil?
    fn = fn + last_name

    return fn
  end

end
