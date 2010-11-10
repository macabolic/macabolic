class CreateReviewSummaries < ActiveRecord::Migration
  def self.up
    create_table :review_summaries do |t|
      t.integer   :product_id
      t.integer   :number_of_reviews
      t.float     :avg_ratings
      t.integer   :number_of_rating_one
      t.integer   :number_of_rating_two
      t.integer   :number_of_rating_three
      t.integer   :number_of_rating_four
      t.integer   :number_of_rating_five
      
      t.timestamps
    end
  end

  def self.down
    drop_table :review_summaries
  end
end
