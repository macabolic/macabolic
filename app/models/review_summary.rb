# == Schema Information
# Schema version: 20101025170952
#
# Table name: review_summaries
#
#  id                     :integer         not null, primary key
#  product_id             :integer
#  number_of_reviews      :integer
#  avg_ratings            :float
#  number_of_rating_one   :integer
#  number_of_rating_two   :integer
#  number_of_rating_three :integer
#  number_of_rating_four  :integer
#  number_of_rating_five  :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class ReviewSummary < ActiveRecord::Base
  belongs_to :product
end
