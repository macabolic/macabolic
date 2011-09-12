class CreateReviewResponses < ActiveRecord::Migration
  def self.up
    create_table :review_responses do |t|
      t.references  :review
      t.references  :user
      t.boolean     :response_for
      
      t.timestamps
    end
  end

  def self.down
    drop_table :review_responses
  end
end
