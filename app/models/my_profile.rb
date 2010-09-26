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
