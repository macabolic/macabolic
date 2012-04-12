class PhotoEntry < ActiveRecord::Base
  belongs_to              :contest,               :class_name => "PhotoContest",  :counter_cache => false
  belongs_to              :poster,                :class_name => "User",  :foreign_key => "poster_id"

  has_attached_file       :photo, 
                          :styles => {  :thumb => ["100x100#", :png],
                                        :small => ["160x160#", :png],
                                        :medium => ["300x300>", :png],
                                        :large => ["640x600>", :png]
                                     },
                          :url => "/assets/photo_entries/:attachment/:id/:style/:basename.:extension",                          
                          :path => ":rails_root/public/assets/photo_entries/:attachment/:id/:style/:basename.:extension"

  validates               :description, 
                          :length => { :maximum => 1000, :too_long => "must have at most %{count} characters" }

  validates_attachment_presence     :photo
  validates_attachment_size         :photo, :less_than => 700000,  :message => "should be less than 700KB."
  validates_attachment_content_type :photo, :content_type => ["image/jpeg", "image/pjpeg", "image/gif", "image/png"], :message => "should be JPG, PNG or GIF."

  paginates_per 1
end
