class PhotoContest < ActiveRecord::Base
  has_many                :entries,           :dependent => :destroy, :class_name => "PhotoEntry"
  
end
